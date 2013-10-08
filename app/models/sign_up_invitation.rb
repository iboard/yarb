# -*- encoding : utf-8 -*-"

# If configured in `config/environments/application_:env_settings.rb` a new
# User will need an invitation to sign up.
class SignUpInvitation
  include Store
  key_method :token
  attribute :token
  validates_presence_of   :token
  validate :unique => true

  def initialize sender, receiver, *options
    @sender_id      = sender.id
    @receiver_email = receiver
    @options        = options.first
  end

  # @return [User]
  def sender
    @sender ||= User.find( @sender_id )
  end

  # @return [String] sender's email
  def from
    @from ||= sender.email
  end

  # @return [String] receiver's email
  def to
    @receiver_email
  end

  # The subject of the mail
  # @return [String] (default "Invitation")
  def subject
    @options.fetch(:subject) { "Invitation" }
  end

  # An optional message provided by the sender
  # @return [String]
  def message
    @options.fetch(:message) { "" }
  end

  # A random invitation token
  # @return [String]
  def token
    @token ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(4) ]
  end

  # Send the mail
  def deliver
    UserMailer.sign_up_invitation(self).deliver
  end
end
