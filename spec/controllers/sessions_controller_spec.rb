require_relative '../spec_helper'

describe SessionController do

  render_views

  it 'logs in a valid user' do
    visit sign_in_path
    fill_in 'EMail', with: 'valid@email.to'
    fill_in 'Password', with: 'secret'
    click_button 'Sign In'
    page_should_have_notice page, 'Successfully signed in as Testuser.'
  end

  it 'does not log in an invalidate user' do
    visit sign_in_path
    fill_in 'EMail', with: 'valid@email.to'
    fill_in 'Password', with: 'insecure'
    click_button 'Sign In'
    page_should_have_error page, 'Invalid Credentials'
  end

end
