# -*- encoding : utf-8 -*-"

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

  def sender
    @sender ||= User.find( @sender_id )
  end

  def from
    @from ||= sender.email
  end

  def to
    @receiver_email
  end

  def subject
    @options.fetch(:subject) { "Invitation" }
  end

  def message
    @options.fetch(:message) { "" }
  end

  def token
    @token ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(4) ]
  end

  def deliver
    UserMailer.sign_up_invitation(self).deliver
  end
end
