require_relative '../spec_helper'

describe SessionController do

  render_views

  before :all do
    create_valid_user 'testuser@example.com', 'Testuser', 'secret'
  end

  describe 'Sign in/out links' do

    after :each do
      sign_out_user
    end

    it 'has a sign-in link' do
      visit root_path
      page.should have_link 'Sign In'
    end

    it 'displays current user and sign-out-link when signed in' do
      sign_in_as 'testuser@example.com', 'secret'
      within ( 'header ul.nav.pull-right' ) do
        page.should have_text 'Testuser'
        page.should have_link 'Sign Out'
      end
    end

    it 'logs out the current user' do
      sign_in_as 'testuser@example.com', 'secret'
      within ( 'header ul.nav.pull-right' ) do
        click_link 'Sign Out'
      end
      page_should_have_notice page, 'You\'re signed out successfully.'
    end
  end

  describe 'Sign In Form' do

    before :each do
      visit sign_in_path
    end

    it 'logs in a valid user' do
      fill_in 'EMail', with: 'testuser@example.com'
      fill_in 'Password', with: 'secret'
      click_button 'Sign In'
      page_should_have_notice page, 'Successfully signed in as Testuser.'
    end

    it 'does not log in an existing user with wrong password' do
      fill_in 'EMail', with: 'testuser@example.com'
      fill_in 'Password', with: 'insecure'
      click_button 'Sign In'
      page_should_have_error page, 'Invalid Credentials'
    end

    it 'does not log in a not existing user' do
      fill_in 'EMail', with: 'not-existing@nowhere.com'
      fill_in 'Password', with: 'whatever'
      click_button 'Sign In'
      page_should_have_error page, 'Invalid Credentials'
    end
  end

end
