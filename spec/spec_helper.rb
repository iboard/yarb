# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/support/matchers'
  add_filter 'spec/spec_helper'
  add_group "App", 'app/'
  add_group "Library", 'lib/'
end


require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

def pstore_path
  r = File.join(Rails.root, 'db', Rails.env.to_s)
end

def sign_in_as user, password
  visit sign_in_path
  fill_in 'EMail', with: user
  fill_in 'Password', with: password
  click_button 'Sign In'
end

def sign_out path=nil
  visit sign_out_path
  visit path if path
end

def create_valid_user email, name, password
  u= User.new email: email, name: name
  u.password = password
  u.save
end

def sign_out_user
  visit sign_out_path
end

def page_should_have_notice page, text
  page.should have_css( '.alert-success', text: text,  match: :prefer_exact )
end

def page_should_have_error page, text
  page.should have_css( '.alert-error', text: text,  match: :prefer_exact )
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

