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
end
