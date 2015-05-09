# -*- encoding : utf-8 -*-"

# Where to read Settings-values from
$SETTINGS_FILE = "../config/environments/application_#{Rails.env}_settings"
require_relative $SETTINGS_FILE

# Settings Module reads settings from config/environment/application_:env_settings.rb
# and provides a method fetch to support easy access to deeply nested hashes.
module Settings

  # SettingsError is thrown when trying to fetch a not defined setting.
  # It reports the missing key and the file where it should be defined.
  class SettingsError < RuntimeError

    # Initializer
    # @param [Symbol] symbol to search for
    # @param [Hash] keys provided in settings
    def initialize symbol, keys
      _keys = keys.empty? ? symbol.to_s : "#{symbol.to_s} in #{keys}"
      super "Missing Setting #{_keys}. See #{$SETTINGS_FILE}"
    end

  end

  # @example
  #   from = Settings.fetch :mailers, :user_mailer, :default_from
  # Access Settings.settings[:symbol][:symbol]... and throws an error
  # if not defined.
  # @param [Array] symbols
  # @return [Object]
  # @raise SettingsError if key not defined
  module_function
  def fetch *symbols
    get_setting( settings, symbols.shift, symbols )
  end

  private
  module_function
  def get_setting( top, symbol, hash )
    _new_hash = top.fetch(symbol) {
      raise SettingsError.new symbol, top
    }
    hash.empty? ? _new_hash : get_setting(_new_hash, hash.shift, hash)
  end

end
