# -*- encoding : utf-8 -*-"

# Send all Mail to developer in developer mode
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = Settings.fetch( :mailers, :developer_email )
  end
end

