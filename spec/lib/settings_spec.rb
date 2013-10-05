# -*- encoding : utf-8 -*-"

require_relative "../spec_helper"

describe "Settings module" do

  it "respond to method settings" do
    expect(Settings.settings).to be_a(Hash)
  end

  it "thorws an exception if top-level setting is not defined" do
    expect{
      Settings.fetch( :not_available )
    }.to raise_error(Settings::SettingsError, /Missing Setting not_available in.* See.*application_test_settings/)
  end

  it "throws an exception if nested value is not defined" do
    expect{
      Settings.fetch( :mailers, :user_mailer, :not_existing )
    }.to raise_error(Settings::SettingsError, 'Missing Setting not_existing in {:default_from=>"noreply@example.com"}. See ../config/environments/application_test_settings')
  end

  it "returns a given value" do
    expect( Settings.fetch :mailers, :user_mailer, :default_from ).to eq("noreply@example.com")
  end
end
