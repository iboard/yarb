# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe Identity do

  before :all do
    I18n.locale = :en
  end

  before :each do
    Authentication.delete_all!
    User.delete_all!
  end

  it "stores secure password for user/authentication" do
    u = create_valid_user "user@example.com", "User", "secure"
    expect( u.authentication( :identity ).authenticate("secure") ).to be_true
    expect( u.authentication( :identity ).authenticate("insecure") ).to be_false
  end

end
