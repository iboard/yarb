# -*- encoding : utf-8 -*-
require_relative Rails.env.test? ? "../test_secrets" :  "../secrets"

Rails.application.config.middleware.use OmniAuth::Builder do

  configure do |config|
    config.path_prefix = '/auth' #unless Rails.env == 'test'
  end

  if Secrets::secret[:omniauth].present?
    Secrets::secret[:omniauth].each do |service, definition|
      provider service.to_sym, definition[:key], definition[:secret]
    end
  end

  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }

  provider :identity,
    :fields => [:email],
    :auth_key => 'email'

  OmniAuth.config.logger = Rails.logger

end

