# -*- encoding : utf-8 -*-"

# Mails to users
class UserMailer < ActionMailer::Base

  # Read default from from settings `config/environments/application_:env_settings.rb
  default from: Settings.fetch(:mailers, :user_mailer, :default_from)

  # Send the invitation E-mail
  # @param [SignUpInvitation] invitation
  def sign_up_invitation invitation
    @invitation = invitation
    mail(from: invitation.from, to: @invitation.to, subject: @invitation.subject )
  end

  # Send Notificaion to admin when new user registered
  # @param [User] _user - the new user signed up
  # @param [Object] _request - http-request
  def new_user_signed_up _user, _request
    @user = _user
    @request_info = build_request_info(_request)
    @domain = Settings.fetch(:app,:hostname)
    mail(
      to: Settings.fetch(:app,:admin_notification_email),
      subject: "New user created at #{@domain}"
    )
  end

  # Send Notificaion to invitor if invitation is used
  # @param [User] user - the new user signed up
  # @param [SignUpInvitation] invitation used
  def invitation_used user, invitation
    if invitation
      @user = user
      @invitation = invitation
      mail( to: invitation.from,
            subject: "Your invitation to #{invitation.to} was just used"
      )
    end
  end

  # Update or create an EmailConfirmation and send email with token
  # @param [User] _user User to send confirmation to
  # @return [Mail] Email
  def request_confirm_email _user
    @confirmation = find_or_create_for_user(_user)
    mail( to: _user.email, subject: "Please confirm your email address")
  end

  # Creates a new email for password reset link
  # @param [String] _email the Email address to sent to
  # @param [String] _token the edit token
  # @return [Mail] Email
  def password_change_token _email, _token
    @token = _token
    mail(to: _email, subject: "Please change your password")
  end

  private

  def find_or_create_for_user user
    EmailConfirmation.find_by(:user_id, user.id) || EmailConfirmation.create(
      user_id: user.id,
      email: user.email,
      token: SecureRandom::hex(24)
    )
  end

  def build_request_info(_request)
    {
      host: _request.host,
      remote_ip: _request.remote_addr,
      params: _request.filtered_parameters,
    }
  end
end
