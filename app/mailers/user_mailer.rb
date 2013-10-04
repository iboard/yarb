# -*- encoding : utf-8 -*-"

class UserMailer < ActionMailer::Base

  default from: Settings.fetch(:mailers, :user_mailer, :default_from)

  def sign_up_invitation invitation
    @invitation = invitation
    mail(from: invitation.from, to: @invitation.to, subject: @invitation.subject )
  end
end
