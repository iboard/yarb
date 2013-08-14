class User

  def self.find_by field, what
    return new
  end

  def name
    'Testuser'
  end

  def email
    'test@ex.com'
  end

  def authenticate _password
    _password.eql?('secret')
  end
end
