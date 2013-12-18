# -*- encoding : utf-8 -*-"


# EmailConfirmations generates a random token for a user and email
# When confirmed! the attribute confirmed_at is set to now.
class EmailConfirmation

  include Persistable

  case STORE_GATEWAY
  when :store
    key_method :token
    attribute  :token, unique: true
    attribute  :email, unique: true
    attribute  :user_id, unique: true
    attribute  :confirmed_at, type: Time

    # @param [Hash] args
    # @option args [String] :email
    # @option args [String] :token
    def initialize args={}
      set_attributes args
    end

  when :mongoid
    field :token
    validates_presence_of  :token
    validates_uniqueness_of :token
    field :_id, type: String, default: ->{ token }
    field  :email
    validates_uniqueness_of :email
    field  :user_id
    validates_uniqueness_of :user_id
    field  :confirmed_at, type: Time, default: nil

    def after_save
      #noop
    end

  else
    raise StoreGatewayNotDefinedError.new
  end



  # Sets the EmailConfirmation to be confirmed
  def confirm!
    self.confirmed_at = Time.now
    save
  end

  # @return [Boolean] true if confirmed_at is set
  def confirmed?
    !self.confirmed_at.nil?
  end

end
