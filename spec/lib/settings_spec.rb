# -*- encoding : utf-8 -*-"

require_relative "../spec_helper"

describe "Settings module" do

  it "respond to method settings" do
    expect(Settings.settings).to be_a(Hash)
  end

  it "thorws an exception if setting is not available" do
    expect{
      Settings.fetch( :not_available )
    }.to raise_error(Settings::SettingsError, "Missing Setting not_available. See ../config/environments/application_test_settings")
  end

  it "returns a given value" do
    expect( Settings.fetch :mailers, :user_mailer, :default_from ).to eq("noreply@example.com")
  end
end
