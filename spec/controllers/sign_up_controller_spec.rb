# -*- encoding : utf-8 -*-

require_relative "../spec_helper"

describe SignUpController do

  render_views

  before(:each) do
    User.delete_all!
    visit sign_up_path
  end

  it "renders a new user form" do
    page.should have_field("Name")
    page.should have_field("e-mail")
    page.should have_field("Password")
    page.should have_field("Confirmation")
  end

  it "creates a valid user" do
    expect{
      fill_in "Name", with: "Frank Valid"
      fill_in "e-mail", with: "valid@example.com"
      fill_in "Password", with: "secret"
      fill_in "Confirmation", with: "secret"
      click_button "Register"
    }.to change{ User.all.count }.by(1)
    page_should_have_notice page, "User valid@example.com successfully created."
  end

  it "doesn't create an already existing user" do
    User.create( name: "Existing", email: "existing@example.com" )
    expect{
      fill_in "Name", with: "Existing"
      fill_in "e-mail", with: "existing@example.com"
      fill_in "Password", with: "secret"
      fill_in "Confirmation", with: "secret"
      click_button "Register"
    }.not_to change { User.all.count }
    page_should_have_error page, "email: e-mail already exists."
  end

  it "doesn't create a user if password confirmation doesn't match" do
    expect{
      fill_in "Name", with: "Another Frank"
      fill_in "e-mail", with: "another.test@example.com"
      fill_in "Password", with: "secret"
      fill_in "Confirmation", with: "word"
      click_button "Register"
    }.not_to change { User.all.count }
    page_should_have_error page, "password_confirmation: Confirmation doesn't match."
  end

  it "doesn't create a user if password to short" do
    expect{
      fill_in "Name", with: "Short Frank"
      fill_in "e-mail", with: "short.test@example.com"
      fill_in "Password", with: "sec"
      fill_in "Confirmation", with: "sec"
      click_button "Register"
    }.not_to change { User.all.count }
    page_should_have_error page, "password: Password is to short. Minimum 4 characters."
  end

  it "doesn't allow empty names" do
    expect{
      fill_in "Name", with: ""
      fill_in "e-mail", with: "empty.test@example.com"
      fill_in "Password", with: "secure"
      fill_in "Confirmation", with: "secure"
      click_button "Register"
    }.not_to change { User.all.count }
    page_should_have_error page, "name: Name can't be blank."
  end



end
