require 'spec_helper'

feature 'The Users forgets his/her password, fills out the form and receives a token email' do
  scenario 'and specifies a valid email address' do
    # Test setup
    create_and_login_admin_user
    ActionMailer::Base.deliveries = []

    # User interaction
    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in :_reset_password_email, with: 'anton@admin.com'
    click_button I18n.t('reset_password')

    # Result (We're on the main page and have an Email and notification)
    expect(page).to have_content(I18n.t('passwort_reset'))
    expect(ActionMailer::Base.deliveries.last.to).to eq(['anton@admin.com'])
  end

  scenario 'and specifies an invalid email address' do
    # Test setup
    create_and_login_admin_user
    ActionMailer::Base.deliveries = []

    # User interaction
    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in :_reset_password_email, with: 'anton-not-here@admin.com'
    click_button I18n.t('reset_password')

    # Result (We're on the main page and have neither Email nor notification)
    expect(page).not_to have_content(I18n.t('passwort_reset'))
    expect(ActionMailer::Base.deliveries.size).to be == 0
  end
end

feature 'The User changes his/her password via the Token Email URL' do
  scenario 'when accessing a plain wrong token url' do
    # Test setup

    # User interaction
    visit edit_password_users_path(token: SecureRandom.hex)

    # Result (we're NOT on the form)
    expect(page).not_to have_content(I18n.t('user.change_password'))
  end

  scenario 'when accessing the Emails URL and changing the password successfully' do
    # Test setup
    create_and_login_admin_user
    ActionMailer::Base.deliveries = []

    # User interaction
    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in :_reset_password_email, with: 'anton@admin.com'
    click_button I18n.t('reset_password')

    user_visits_link_in_email(ActionMailer::Base.deliveries.last)
    fill_in :password, with: '12345678'
    fill_in :password_confirmation, with: '12345678'
    click_button I18n.t('save')

    # Result (we're on the main page and have a notification)
    expect(page).to have_content('Password changed')
  end

  scenario 'when accessing the Emails URL and changing the password unsuccessfully' do
    # Test setup
    create_and_login_admin_user
    ActionMailer::Base.deliveries = []

    # User interaction
    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in :_reset_password_email, with: 'anton@admin.com'
    click_button I18n.t('reset_password')

    user_visits_link_in_email(ActionMailer::Base.deliveries.last)
    fill_in :password, with: '12345678'
    fill_in :password_confirmation, with: '123456789'
    click_button I18n.t('save')

    # Result (we have a notification)
    expect(page).to have_content('Passwords did not match')
  end
end
