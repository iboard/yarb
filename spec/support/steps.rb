# -*- encoding : utf-8 -*-

def pstore_path
  r = File.join(Rails.root, 'db', Rails.env.to_s)
end

def sign_in_as email, password
  visit sign_in_path
  fill_in 'EMail', with: email
  fill_in 'Password', with: password
  click_button 'Sign In'
end

def sign_out path=nil
  visit sign_out_path
  visit path if path
end

def create_valid_user email, name, password
  u= User.new email: email, name: name
  u.password = password
  u.save
end

def create_admin_user email, name, password
  u = create_valid_user email, name, password
  u.roles = [:admin]
  u.save
end

def sign_out_user
  visit sign_out_path
end

def page_should_have_notice page, text
  page.should have_css( '.alert-success', text: text,  match: :prefer_exact )
end

def page_should_have_error page, text
  page.should have_css( '.alert-error', text: text,  match: :prefer_exact )
end

