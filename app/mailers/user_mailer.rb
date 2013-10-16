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

  private

  def build_request_info(_request)
    {
      host: _request.host,
      remote_ip: _request.remote_addr,
      params: _request.filtered_parameters,
    }
  end
end
