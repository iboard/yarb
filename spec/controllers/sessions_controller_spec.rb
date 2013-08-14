require_relative '../spec_helper'

describe SessionController do

  render_views

  describe 'Sign in/out links' do

    it 'has a sign-in link' do
      visit root_path
      page.should have_link 'Sign In'
    end

    it 'displays current user and sign-out-link when signed in' do
      sign_in_as 'Testuser', 'secret'
      within ( 'header ul.nav.pull-right' ) do
        page.should have_text 'Testuser'
        page.should have_link 'Sign Out'
      end
    end
  end

  describe 'Sign In Form' do

    before :each do
      visit sign_in_path
    end

    it 'logs in a valid user' do
      fill_in 'EMail', with: 'valid@email.to'
      fill_in 'Password', with: 'secret'
      click_button 'Sign In'
      page_should_have_notice page, 'Successfully signed in as Testuser.'
    end

    it 'does not log in an invalidate user' do
      fill_in 'EMail', with: 'valid@email.to'
      fill_in 'Password', with: 'insecure'
      click_button 'Sign In'
      page_should_have_error page, 'Invalid Credentials'
    end
  end

end
