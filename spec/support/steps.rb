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
  u.save
  u.password= password
  u
end

def create_confirmed_user email, name, password
  user = create_valid_user email, name, password
  confirm_from_last_email
  user
end

def create_unconfirmed_user email, name, password
  user = create_valid_user email, name, password
  expect(user.email_confirmed?).to be_false
  user
end

def confirm_from_last_email
  email_confirmation = case STORE_GATEWAY
                       when :store
                         EmailConfirmation.find_by(:token, get_last_email_confirmation_token)
                       when :mongoid
                         EmailConfirmation.where(token: get_last_email_confirmation_token).first
                       else
                         raise StoreGatewayNotDefinedError.new
                       end
  email_confirmation.confirm!
end

def get_last_email_confirmation_token
  last_mail.body.to_s.scan(/confirm_email\/([0-9a-f]+)\s/).flatten.first
end

def create_valid_user_with_authentication args
  user = create_valid_user args[:info][:email], args[:info][:name], "notused"
  identity_auth = user.authentication(:identity)
  Authentication.create!( provider: args[:provider], uid: args[:uid], user_id: user.id)
  Identity.find_by(:authentication_id, identity_auth.id).delete
  user
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

