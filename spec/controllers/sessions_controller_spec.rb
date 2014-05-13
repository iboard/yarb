# -*- encoding : utf-8 -*-
require_relative "../spec_helper"

describe SessionController do

  render_views

  before :all do
    create_valid_user "testuser@example.com", "Testuser", "secret"
  end

  context "handles sign in and sign out" do

    describe "In the header nav" do
      after :each do
        sign_out_user
      end

      it "has a sign-in link" do
        visit root_path
        page.should have_link "Sign In"
      end

      it "displays current user and sign-out-link when signed in" do
        sign_in_as "testuser@example.com", "secret"
        within ("header ul.nav.pull-right") do
          page.should have_text "Testuser"
          page.should have_link "Sign Out"
        end
      end

      it "logs out the current user" do
        sign_in_as "testuser@example.com", "secret"
        within ("header ul.nav.pull-right") do
          click_link "Sign Out"
        end
        page_should_have_notice page, "You're signed out successfully."
      end
    end

    describe "The Sign In Form" do

      before :each do
        visit sign_in_path
      end

      it "logs in a valid user" do
        fill_in "EMail", with: "testuser@example.com"
        fill_in "Password", with: "secret"
        click_button "Sign In"
        page_should_have_notice page, "Successfully signed in as Testuser."
      end

      it "does not log in an existing user with wrong password" do
        fill_in "EMail", with: "testuser@example.com"
        fill_in "Password", with: "insecure"
        click_button "Sign In"
        page_should_have_error page, "Invalid Credentials"
      end

      it "does not log in a not existing user" do
        fill_in "EMail", with: "not-existing@nowhere.com"
        fill_in "Password", with: "whatever"
        click_button "Sign In"
        page_should_have_error page, "Invalid Credentials"
      end
    end

    describe 'GET #forgot_password (/forgot_password)' do
      before(:each) { get :forgot_password }

      it 'returns with status 200' do
        expect(response).to be_ok
      end

      it 'displays a form for retrieving a forgotten password' do
        expect(response).to render_template(:forgot_password)
      end
    end

    describe 'POST #reset_password (/reset_password)' do
      context 'for existing User' do
        before(:each) { post :reset_password, '/reset_password' => { email: 'testuser@example.com' } }

        it 'returns with redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(sign_in_path)
        end

        it 'displays a notice upon redirect' do
          expect(flash.notice).to include(I18n.t('passwort_reset'))
        end

        it 'calls User#create_edit_token' do
          expect_any_instance_of(User).to receive(:create_edit_token!)
          post :reset_password, '/reset_password' => { email: 'testuser@example.com' }
        end
      end

      context 'for non-existing User' do
        before(:each) { post :reset_password, '/reset_password' => { email: 'not-here@example.com' } }

        it 'returns with redirect' do
          expect(response).to be_redirect
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(sign_in_path)
        end
      end
    end
  end
end
