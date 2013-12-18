# -*- encoding : utf-8 -*-"

# An Authentication belongs to a user.
# A User can have more authentications (Identity, Google, Twitter, ...)
class Authentication

  include Persistable

  case STORE_GATEWAY
  when :store
    key_method :id
    attribute  :id
    attribute  :provider, default: :identity
    attribute  :uid
    attribute  :user_id

    def _id
      id
    end

    def initialize *args
      set_attributes( *args )
      ensure_identity
    end

    # @return [String] "hex1-hex2" hex1=Time.now, hex2=random
    def id
      @id ||= "%x-%s" % [Time.now.to_i, SecureRandom::hex(4)]
    end
  when :mongoid
    field :_id, type: String, default: ->{ "%x-%s" % [Time.now.to_i, SecureRandom::hex(4)] }
    field :provider, default: :identity
    field :uid
    field :user_id

    def initialize *args
      super
      ensure_identity
    end

    def after_save
      #noop
    end
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
      STORE_GATEWAY == :mongoid ? Identity.where(authentication_id: _id).first : Identity.find_by(:authentication_id, _id)
    end
  end


  # Set new password
  # @param [String] new_password
  def password= new_password
    case STORE_GATEWAY
    when :mongoid
      if identity
        identity.password= new_password
      else
        Identity.create( authentication_id: _id, password: new_password )
      end
    when :store
      Identity.create( authentication_id: _id, password: new_password ) if identity
    else
      raise StoreGatewayNotDefinedError.new
    end
  end

  # Delete Identities before deleting self
  def delete
    Identity.where( authentication_id: _id ).each { |i| i.delete }
    super
  end

  private
  def ensure_identity
    if provider == :identity && identity.nil?
      Identity.create authentication_id: _id
    end
  end

end

