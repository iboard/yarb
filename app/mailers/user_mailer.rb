# -*- encoding : utf-8 -*-"

class UserMailer < ActionMailer::Base

  default from: Settings::settings.fetch(:mailers) {
                  raise SettingsError.new("Missing settings[:mailers]")
                }.fetch(:user_mailer) {
                  raise SettingsError.new("Missing settings[:mailers][:user_mailer]")
                }.fetch(:default_from) {
                  raise SettingsError.new("Missing settings[:mailers][:user_mailer][:default_from]")
                }

  def sign_up_invitation invitation
    @invitation = invitation
    mail(from: invitation.from, to: @invitation.to, subject: @invitation.subject )
  end
end
