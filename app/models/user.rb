# -*- encoding : utf-8 -*-


# The User-class
# * uses BCrypt to encrypt passwords
# * key :id is equal to :email but used parameterized by module Store
class User

  include Store
  include Store::Timestamps
  include Roles

  key_method :id
  attribute  :email, unique: true
  validates_presence_of :email

  attribute  :name
  validates_presence_of :name


  def initialize args={}
    set_attributes args
    ensure_authentication
  end

  # Create a user without Identity but with an OAuth-provider
  # @param [Hash] auth OmniAuth authentication-hash
  # @return [User] the user created
  def self.create_from_auth auth
     Store::expire_selectors_for User, Identity, Authentication
     _user = create name: auth[:info][:name], email: auth[:info][:email]
     _user.replace_old_authentication(auth) unless auth[:provider] == :identity
  end

  # Replace an existing authentication(:identity) - don't call if current authentication is :identity
  # @param [Hash] auth - the authentication-hash
  # @option auth [String|Symbol] :provider (eg :identity, 'twitter', ...)
  # @option auth [String|Symbol] :uid - Unique ID for provider
  # @return [Autentication] newly created authentication
  def replace_old_authentication auth
    authentication.delete
   Authentication.create provider: auth[:provider], uid: auth[:uid], user_id: id
    self
  end

  # Creates a unique id for the user.
  # @return [String]
  def id
    @id ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(2) ]
  end

  # ensure we have a valid id
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

  delegate "password",               to: :authentication
  delegate "password=",              to: :authentication
  delegate "password_confirmation",  to: :authentication
  delegate "password_confirmation=", to: :authentication
  delegate "authenticate",           to: :authentication
  delegate "old_password",           to: :authentication
  delegate "old_password=",          to: :authentication

  # Delete an existing authentication (for :identity) and create a new one
  # @param [String|Symbol] provider
  # @param [String] uid - user's id at provider
  # @return [Authentication]
  def recreate_authentication provider, uid
    authentication.delete
    Authentication.create! provider: provider, uid: uid, user_id: id
  end

  private
  def ensure_authentication
    Authentication.find_by( :user_id, id ) || Authentication.create!(user_id: id)
  end

end
