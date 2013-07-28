ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

def pstore_path
  r = File.join(Rails.root, 'db', Rails.env.to_s)
end

RSpec.configure do |config|
  config.include Capybara::DSL
  Capybara.configure do |cfg|
    cfg.match = :one
    cfg.exact_options = true
    cfg.ignore_hidden_elements = true
    cfg.visible_text_only = true
    cfg.javascript_driver = :webkit
  end

  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.color_enabled = true

  config.before(:all) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{pstore_path}/[^.]*"])
    end
  end
end

