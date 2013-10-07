# -*- encoding : utf-8 -*-
#
# Settings Hash for test-environment
module Settings

  def self.settings
    {
      app: {
        hostname: "EXAMPLE.COM",
        needs_invitation: false,
      },
      smtp: {
        host: "example.com",
        server: "your.mail.server",
        port: 25,
        domain: "your.domain",
        default_from: "noreply@your.domain",
        authentication: 'plain',
        enable_starttls_auto: true,
        user: 'smtpusername',
        password: 'smtpuser-password', # Make sure this is not in your repository!
      },
      mailers: {
        user_mailer: {
          default_from: "noreply@example.com",
        }
      },
    }
  end

end
