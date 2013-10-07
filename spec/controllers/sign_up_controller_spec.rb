# -*- encoding : utf-8 -*-

require_relative "../spec_helper"

describe SignUpController do

  render_views

  context "Without invitation enabled" do

    before(:each) do
      User.delete_all!
      visit sign_up_path
    end

    it "renders a new user form" do
      page.should have_field("Name")
      page.should have_field("e-mail")
      page.should have_field("Password")
      page.should have_field("Confirmation")
      page.should_not have_field("Invitation")
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

    context "Using omniauth" do

      before :each do
        User.delete_all!
        Authentication.delete_all!
        Identity.delete_all!
        OmniAuth.config.add_mock(:twitter, {
          :uid => "12345",
          :provider => "twitter",
          :info => { name: "Test User", nickname: "twitter-user" }
        })
      end

      context "Sign Up" do

        def use_twitter
          click_link "Twitter"
          fill_in "e-mail", with: "twitter@iboard.cc"
          click_button "Register"
        end

        it "creates a new user" do
          expect { use_twitter }.to change{ User.all.count }.by(1)
          page_should_have_notice page, "Successfully signed in as Test User"
        end

        it "creates a new authentication" do
          expect { use_twitter }.to change{ Authentication.all.count }.by(1)
          page_should_have_notice page, "Successfully signed in as Test User"
        end

        it "doesn't create an identity" do
          expect { use_twitter }.to change{ Identity.all.count }.by(0)
          page_should_have_notice page, "Successfully signed in as Test User"
        end
      end

      context "Sign In" do

        it "signs in an existng user" do
          user = create_valid_user_with_authentication(provider: "twitter", uid: "12345",
            :info => { name: "Test User", nickname: "twitter-user", email: "andi@test.cc" })
          visit sign_in_path
          click_link "Twitter"
          page_should_have_notice page, "Successfully signed in as Test User"
        end

        it "catches OAuth::Unauthorized" do
          OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
          visit sign_in_path
          click_link "Twitter"
          page_should_have_error page, "Authentication failed with, Invalid Credentials"
        end

        it "catches exception when user/password is used for an existing twitter-user" do
          user = create_valid_user_with_authentication(provider: "twitter", uid: "12345",
            :info => { name: "Test User", nickname: "twitter-user", email: "andi@test.cc" })
          visit sign_in_path
          fill_in "EMail", with: "andi@test.cc"
          fill_in "Password", with: "wrong login"
          click_button "Sign In"
          page_should_have_error page, "Invalid Credentials"
        end

      end

    end

  end

  context "With invitations enabelde" do

    before(:each) do
      User.delete_all!
      @host_user = create_admin_user "host@example.com", "Host", "secret"
      @invitation = SignUpInvitation.new @host_user, "guest@example.com"
      @invitation.save
      ApplicationHelper.stub(:needs_invitation?).and_return(true)
    end

    let(:host)       { @host_user  }
    let(:invitation) { @invitation }

    it "renders a new user form" do
      visit sign_up_path
      page.should  have_field("Invitation")
    end

    it "creates a valid user with invitation" do
      visit accept_sign_up_invitation_path( invitation.token )
      expect{
        fill_in "Name", with: "Frank Valid"
        fill_in "e-mail", with: "valid@example.com"
        fill_in "Password", with: "secret"
        fill_in "Confirmation", with: "secret"
        find_field('Invitation').value.should eq invitation.token
        click_button "Register"
      }.to change{ User.all.count }.by(1)
      page_should_have_notice page, "User valid@example.com successfully created."
    end

    it "doesn't create a user with invalid invitation" do
      visit accept_sign_up_invitation_path( invitation.token )
      expect{
        fill_in "Name", with: "Frank Valid"
        fill_in "e-mail", with: "valid@example.com"
        fill_in "Password", with: "secret"
        fill_in "Confirmation", with: "secret"
        fill_in "Invitation", with: "not-valid-invitation"
        click_button "Register"
      }.not_to change{ User.all.count }.by(1)
      page_should_have_error page, "Invalid invitation token."
    end

    context "Using omniauth" do

      before :each do
        OmniAuth.config.add_mock(:twitter, {
          :uid => "12345",
          :provider => "twitter",
          :info => { name: "Test User", nickname: "twitter-user" }
        })
      end

      def use_twitter_with_token _token
        visit accept_sign_up_invitation_path( _token )
        click_link "Twitter"
        fill_in "e-mail", with: "twitter@iboard.cc"
        click_button "Register"
      end

      it "creates a new user" do
        expect { use_twitter_with_token(invitation.token) }.to change{ User.all.count }.by(1)
        page_should_have_notice page, "Successfully signed in as Test User"
      end

      it "doesn't create a user with invalid token" do
        expect { use_twitter_with_token("not-valid") }.not_to change{ User.all.count }.by(1)
        page_should_have_error page, "Can't create user."
      end
    end

  end

end
