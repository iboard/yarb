# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe UsersController do

  render_views

  context "with an existing user" do

    before :each do
      User.delete_store!
    end

    it "GET /users/:id shows the user name on the user's page" do
      user = create_valid_user "test@example.com", "Testuser", "secret"
      sign_in_as "test@example.com", "secret"
      visit user_path(user)
      within( "#user-#{user.id}" ) do
        page.should have_content user.name
        page.should have_content user.id
        page.should have_content user.email
      end
    end

    it "GET /users/:id/edit renders the users form" do
      user = create_valid_user "test@example.com", "Testuser", "secret"
      sign_in_as "test@example.com", "secret"
      visit edit_user_path(user)
      within( "#edit-user-#{user.id}" ) do
        page.should have_field "Name"
        page.should have_field "e-mail"
        page.should have_field "Old Password"
        page.should have_field "New Password"
        page.should have_field "Confirmation"
      end
    end

    it "PUT /user/:id updates the user record without changing the password" do
      user = create_valid_user "test@example.com", "Testuser", "secret"
      sign_in_as "test@example.com", "secret"
      visit edit_user_path(user)
      within( "#edit-user-#{user.id}" ) do
        fill_in "Name", with: "Frank Zappa"
        fill_in "e-mail", with: "frank@zappa.com"
        click_button "Save"
      end
      page_should_have_notice page, "User Profile for frank@zappa.com successfully updated."
      within( ".user-fields" ) do
        page.should have_content "Frank Zappa"
        page.should have_content "frank@zappa.com"
      end
    end

    it "PUT /user/:id renders :edit again if errors" do
      user = create_valid_user "test@example.com", "Testuser", "secret"
      sign_in_as "test@example.com", "secret"
      visit edit_user_path(user)
      within( "#edit-user-#{user.id}" ) do
        fill_in "Name", with: ""
        click_button "Save"
      end
      page_should_have_error page, "name: can't be blank"
    end

    context "Changing the password" do

      before :each do
        @user = create_valid_user "test@example.com", "Testuser", "oldpassword"
        sign_in_as "test@example.com", "oldpassword"
        visit edit_user_path(@user)
      end

      it "PUT /user/:id updates password if entered" do
        within( "#edit-user-#{@user.id}" ) do
          fill_in "Old Password", with: "oldpassword"
          fill_in "New Password", with: "verysecret"
          fill_in "Confirm",      with: "verysecret"
          click_button "Save"
        end
        expect( @user.reload.authenticate( "verysecret" ) ).to be_true
      end

      it "PUT /user/:id doesn't update password when old password isn't correct" do
        within( "#edit-user-#{@user.id}" ) do
          fill_in "Old Password", with: "wrong password"
          fill_in "New Password", with: "verysecret"
          fill_in "Confirm",      with: "verysecret"
          click_button "Save"
        end
        page_should_have_error page, "old_password: Old password isn't correct."
        expect( @user.reload.authenticate( "oldpassword" ) ).to be_true
      end


      it "PUT /user/:id doesn't update password when confirmation doesn't match" do
        within( "#edit-user-#{@user.id}" ) do
          fill_in "Old Password", with: "oldpassword"
          fill_in "New Password", with: "verysecret"
          fill_in "Confirm",      with: "verysekret"
          click_button "Save"
        end
        page_should_have_error page, "password_confirmation: Password confirmation doesn't match."
        expect( @user.reload.authenticate( "oldpassword" ) ).to be_true
      end

      it "PUT /user/:id doesn't update password when to short" do
        within( "#edit-user-#{@user.id}" ) do
          fill_in "Old Password", with: "oldpassword"
          fill_in "New Password", with: "ver"
          fill_in "Confirm",      with: "ver"
          click_button "Save"
        end
        page_should_have_error page, "new_password: Password is to short. Minimum 4 characters."
        expect( @user.reload.authenticate( "oldpassword" ) ).to be_true
      end

      context "for an OAuth-User" do

        before :each do
          User.delete_all!
          Authentication.delete_all!
          Identity.delete_all!
          OmniAuth.config.add_mock(:twitter, {
            :uid => "12345",
            :provider => "twitter",
            :info => { name: "Test User", nickname: "twitter-user", email: "test@example.com" }
          })
        end

        it "doesn't offer to change the password" do
          visit sign_in_path
          click_link "Twitter"
          click_link "Test User"
          click_link "Edit"
          page.should_not have_content "Change Your Password"
          page.should_not have_field "Old Password"
          page.should_not have_field "New Password"
          page.should_not have_field "Confirmation"
        end

      end

    end

  end

  context "as a non-admin" do

    it "doesn't show the user-index-page" do
      get :index, { controller: "users" }
      expect(response.status).to eq(404)
    end

  end

  context "as an admin-user" do

    before :each do
      I18n.locale = :en
      User.delete_store!
      @admin = create_admin_user "admin@example.com", "Admin",  "secret"
               create_valid_user "user1@example.com", "User1",  "secret"
      @user2 = create_valid_user "user2@example.com", "User2", "secret"
      ApplicationController.any_instance.stub(:current_user).and_return( User.all.first )
      visit users_path
    end

    it "shows the user-index page" do
      page.should have_content "Listing Users"
      within("#user-list") do
        page.should have_content "Admin"
        page.should have_content "User1"
        page.should have_content "User2"
      end
    end

    it "allows to delete a user" do
      within("#user-#{@user2.id}") do
        click_link "Delete"
      end
      page_should_have_notice page, "× User 'User2' successfully deleted."
      within("#user-list") do
        page.should have_content "Admin"
        page.should have_content "User1"
        page.should_not have_content "User2"
      end
    end

    it "has checkboxes for roles in user#edit" do
       visit edit_user_path(@user2)
       check "Admin"
       check "Editor"
       click_button "Save"
       u = User.find(@user2.id)
       expect( u.roles ).to eq( [:editor, :admin] )
    end

  end

end


