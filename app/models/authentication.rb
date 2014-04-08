# -*- encoding : utf-8 -*-"

# An Authentication belongs to a user.
# A User can have more authentications (Identity, Google, Twitter, ...)
class Authentication

  include Persistable

  key_method :id
  attribute  :id
  attribute  :provider, default: :identity
  attribute  :uid
  attribute  :user_id

  # Initializer
  # @param [Hash] args attribute Hash
  # @return [Authentication]
  def initialize *args
    set_attributes( *args )
    ensure_identity
  end

  # @return [String] "hex1-hex2" hex1=Time.now, hex2=random
  def id
    @id ||= "%x-%s" % [Time.now.to_i, SecureRandom::hex(4)]
  end

  delegate "password",               to: :identity
  delegate "authenticate",           to: :identity
  delegate "old_password",           to: :identity
  delegate "old_password=",          to: :identity
  delegate "password_confirmation",  to: :identity
  delegate "password_confirmation=", to: :identity

  # @return [Identity] joined by authentication_id if provider is :identity
  def identity
    if provider == :identity
      Identity.find_by(:authentication_id, id)
    end
  end


  # Set new password
  # @param [String] new_password
  def password= new_password
    Identity.create( authentication_id: self.id, password: new_password ) if identity
  end

  # Delete Identities before deleting self
  def delete
    Identity.where( authentication_id: id ).each { |i| i.delete }
    super
  end

  private
  def ensure_identity
    if provider == :identity && identity.nil?
      Identity.create authentication_id: id
    end
  end

end

