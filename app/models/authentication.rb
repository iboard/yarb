# -*- encoding : utf-8 -*-"

class Authentication

  include Store
  include Store::Timestamps
  key_method :id
  attribute  :id
  attribute  :user_id
  attribute  :provider, default: :identity

  def initialize *args
    set_attributes( *args )
    ensure_identity
  end

  def id
    @id ||= "%x-%s" % [Time.now.to_i, SecureRandom::hex(4)]
  end

  def authenticate password
    identity.authenticate(password) if provider == :identity
  end

  def identity
    if provider == :identity
      Identity.find_by(:authentication_id, id) || NilIdentity.new
    end
  end

  def identity= new_identity
    #noop
  end


  delegate "password",     to: :identity
  delegate "authenticate", to: :identity
  delegate "old_password", to: :identity
  delegate "old_password=",to: :identity
  delegate "password_confirmation",     to: :identity
  delegate "password_confirmation=",    to: :identity

  def password= new_password
    Identity.create( authentication_id: self.id ) if identity.is_a?(NilIdentity)
    identity.password=new_password
  end

  private
  def ensure_identity
    if provider == :identity && identity.is_a?(NilIdentity)
      Identity.create authentication_id: id
    end
  end

end

