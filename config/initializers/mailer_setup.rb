# -*- encoding : utf-8 -*-"
#
require_relative "../../lib/settings"
require_relative "../../lib/development_mail_interceptor"
include Settings

_options = {
    :address              => Settings.fetch(:smtp, :server),
    :port                 => Settings.fetch(:smtp, :port),
    :domain               => Settings.fetch(:smtp, :domain),
    :authentication       => Settings.fetch(:smtp, :authentication),
    :enable_starttls_auto => Settings.fetch(:smtp, :enable_starttls_auto),
}

if Settings.fetch(:smtp, :authentication) == "plain"
  _options.merge!(
      :user_name            => Settings.fetch(:smtp, :user ),
      :password             => Settings.fetch(:smtp, :password ),
  )
end

ActionMailer::Base.smtp_settings = _options
ActionMailer::Base.default_url_options[:host] = Settings.fetch(:smtp, :host)
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
