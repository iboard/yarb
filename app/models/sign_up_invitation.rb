# -*- encoding : utf-8 -*-"

# If configured in `config/environments/application_:env_settings.rb` a new
# User will need an invitation to sign up.
class SignUpInvitation
  include Persistable

  case STORE_GATEWAY
  when :store
    key_method :token
    attribute :token, :unique => true
    attribute :to,    :unique => true, :email => true
    validates_presence_of   :token
    validates_presence_of   :to

    # @param [User] sender
    # @param [String] receiver (email-address)
    # @param [Hash] options (optional)
    # @option options [String] :subject Subject for the email
    # @option options [String] :message (optional message for the body of the email)
    def initialize sender, receiver, *options
      @sender_id      = sender.id
      @receiver_email = receiver
      @options        = options.first
    end

  when :mongoid
    field :token, type: String, default: -> { "%x-%s" % [ Time.now.to_i, SecureRandom::hex(4) ] }
    validates_presence_of :token
    validates_uniqueness_of :token
    field :_id, type: String, default: ->{ token }
    field :to
    field :sender_id
    field :options, type: Hash, default: {}
    validates_presence_of :to
    validates_uniqueness_of :to

    def initialize sender, receiver, *_options
      super to: receiver, sender_id: sender._id, options: _options.first
    end

    def after_save
      #noop
    end
  else
    raise StoreGatewayNotDefinedError.new
  end


  # @return [User]
  def sender
    _sender_id = STORE_GATEWAY == :mongoid ? self.sender_id : @sender_id
    @sender ||= User.find( _sender_id )
  end

  # @return [String] sender's email
  def from
    @from ||= sender.email
  end

  unless STORE_GATEWAY == :mongoid
    # @return [String] receiver's email
    def to
      @receiver_email
    end
  end

  # The subject of the mail
  # @return [String] (default "Invitation")
  def subject
    case STORE_GATEWAY
    when :store
      @options.fetch(:subject) { "Invitation" }
    when :mongoid
      self.options.fetch(:subject) { "Invitation" }
    else
      raise StoreGatewayNotDefinedError.new
    end
  end

  # An optional message provided by the sender
  # @return [String]
  def message
    case STORE_GATEWAY
    when :store
      @options.fetch(:message) { "" }
    when :mongoid
      self.options.fetch(:message) { "" }
    else
      raise StoreGatewayNotDefinedError.new
    end
  end

  # A random invitation token
  # @return [String]
  unless STORE_GATEWAY == :mongoid
    def token
      @token ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(4) ]
    end
  end

  # Send the mail
  def deliver
    UserMailer.sign_up_invitation(self).deliver
  end
end
