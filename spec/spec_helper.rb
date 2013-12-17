# -*- encoding : utf-8 -*-

# SETUP THE ENVIRONMENT AND SIMPLE_COV
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/support/matchers'
  add_filter 'spec/support/warning_suppressor'
  add_filter 'spec/spec_helper'
  add_filter 'lib/development_mail_interceptor.rb'
  add_group "App", 'app/'
  add_group "Library", 'lib/'
end

# REQUIRE RAILS-ENVIRONMENT AND LIBS
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

# LOADING OWN SPEC-SUPPORT FILES
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# CONFIGURING RSPEC
RSpec.configure do |config|

  # CONFIG CAPYBARA
  config.include Capybara::DSL
  Capybara.configure do |cfg|
    cfg.match = :one
    cfg.exact_options = true
    cfg.ignore_hidden_elements = true
    cfg.visible_text_only = true
    cfg.javascript_driver = :webkit
  end

  # SETUP RSPEC OPTIONS
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.color_enabled = true

  config.before(:all) do

    # SET LOCALE
    # during test locale comes from your workstation's user
    # make sure it is :en even on german or other consoles
    I18n.locale = :en

    # MAKE SURE WE START WITH A CLEAN/EMPTY DATA-PATH
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{pstore_path}/[^.]*"])
    end

    # CLEAN MONGO DB
    Mongoid.purge!

    # FAKE OMNIAUTH CALLS
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :uid => '123545'
    })
  end

end

