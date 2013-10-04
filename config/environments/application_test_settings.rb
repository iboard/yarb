# -*- encoding : utf-8 -*-
#
# Settings Hash for test-environment
module Settings

  class SettingsError < RuntimeError
    def initialize missing_entry
      @missing_entry = missing_entry
    end

    def message
      "Missing definition of Settings.settings#{@missing_entry}"
    end
  end

  def self.settings
    {
      mailers: {
        user_mailer: {
          default_from: "noreply@example.com",
        }
      },
    }
  end

end
