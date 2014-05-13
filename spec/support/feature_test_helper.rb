module FeatureTestHelper
  def create_and_login_admin_user
    create_and_login_user 'Anton Admin', 'anton@admin.com', [:admin], '12345'
  end

  def create_and_login_user(_name, _email, _roles, _password)
    create_user(_name, _email, _roles, _password)
    sign_in_as(_email, _password)
  end

  def sign_in_as(_email, _password)
    visit sign_in_path
    fill_in 'EMail', with: _email
    fill_in 'Password', with: _password
    click_button 'Sign In'
  end

  def user_visits_link_in_email(_email)
    _link = URI.extract(_email.body.to_s, ['http', 'https'])[0]
    _uri = URI.parse(_link)
    _path = _uri.path
    _query = _uri.query
    _target = "#{_path}?#{_query}"
    visit _target
  end

  private

  def create_user(_name, _email, _roles, _password)
    _user = User.create name: _name, email: _email, roles: _roles
    _user.password = _password
    _user.save
  end

end