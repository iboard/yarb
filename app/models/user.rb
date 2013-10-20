# -*- encoding : utf-8 -*-


# The User-class
# * uses BCrypt to encrypt passwords
# * key :id is equal to :email but used parameterized by module Store
class User

  include Persistable
  include Roles

  key_method :id
  attribute  :email, unique: true
  validates_presence_of :email

  attribute  :name
  validates_presence_of :name

  # @param [Hash] args
  # @option args [String] :name - The username
  # @option args [String] :email - User's email
  def initialize args={}
    set_attributes args
    ensure_authentication
  end

  # Create a user without Identity but with an OAuth-provider
  # @param [Hash] auth OmniAuth authentication-hash
  # @return [User] the user created
  def self.create_from_auth auth
     create_user_with_auth auth
  end

  # Creates a unique id for the user.
  # @return [String]
  def id
    @id ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(2) ]
  end

  # ensure we have a valid id and authentication
  def save
    id and ensure_authentication and super
  end

  # Delete Authentications before deleting self
  def delete
    Authentication.where(user_id: id).each { |auth| auth.delete }
    super
  end

  # @param [Symbol] provider (default :identity)
  # @return [Authentication]
  def authentication provider=:identity
    Authentication.where(user_id: id, provider: provider).all.first
  end

  # Delete an existing authentication (for :identity) and create a new one
  # @param [String|Symbol] provider
  # @param [String] uid - user's id at provider
  # @return [Authentication]
  def recreate_authentication provider, uid
    authentication.delete
    Authentication.create! provider: provider, uid: uid, user_id: id
  end

  # Replace an existing authentication(:identity)
  # @param [Hash] auth - the authentication-hash
  # @option auth [String|Symbol] :provider (eg :identity, 'twitter', ...)
  # @option auth [String|Symbol] :uid - Unique ID for provider
  # @return [User] user with newly created authentication
  def recreate_authentication_with_hash auth
    recreate_authentication auth[:provider], uid: auth[:uid]  unless identity?(auth)
    self
  end

  # @return [Boolean] true if email is marked as confirmed
  def email_confirmed?
    @confirmation = EmailConfirmation.find_by( :user_id, self.id )
    @confirmation && @confirmation.confirmed?
  end

  # @return [Time|String] time of confirmed_at or 'n/a'
  def confirmed_at
    email_confirmed? ? @confirmation.confirmed_at : "n/a"
  end

  private

  def self.create_user_with_auth auth
    _user = create auth_user_params(auth)
    _user.recreate_authentication_with_hash(auth)
  end

  def self.auth_user_params(auth)
    { name: auth[:info][:name], email: auth[:info][:email] }
  end

  def identity? auth
    auth[:provider] == :identity
  end

  def ensure_authentication
    Authentication.find_by( :user_id, id ) || Authentication.create!(user_id: id)
  end

  # delegate password-methods to Authentication
  delegate "password",               to: :authentication
  delegate "password=",              to: :authentication
  delegate "password_confirmation",  to: :authentication
  delegate "password_confirmation=", to: :authentication
  delegate "authenticate",           to: :authentication
  delegate "old_password",           to: :authentication
  delegate "old_password=",          to: :authentication

  def after_save
    super
    request_confirm_email
    self
  end

  def request_confirm_email
    UserMailer.request_confirm_email(self).deliver if needs_confirmation?
  end

  def needs_confirmation?
    c = EmailConfirmation.find_by(:user_id, self.id)
    if c && c.email != self.email
      c.delete
      true
    elsif c.nil?
      true
    else
      false
    end
  end

end
