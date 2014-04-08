# -*- encoding : utf-8 -*-"

# Send all Mail to developer in developer mode
class DevelopmentMailInterceptor

  # Redirect all mails to developer's email
  # Used only in development-mode (see `config/initializers/mailer_setup`)
  # @param [TMail] message - message to deliver
  # @return [void]
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = Settings.fetch( :mailers, :developer_email )
  end
end

