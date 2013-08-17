require 'bcrypt'

# The User-class 
# * uses BCrypt to encrypt passwords
# * key :id is equal to :email but used parameterized by module Store
class User

  include Store
  include BCrypt
  include Roles

  key_method :id
  attribute  :email
  validates_presence_of :email

  attribute  :name
  validates_presence_of :name

  attribute :password_digest
  
  # id is used as the key_method.
  # Since keys are parameterized we can't use email directly 
  # Therefore we return the email-field as id.
  # TODO: Something smells here - refactor this.
  # @return [String]
  def id
    email
  end

  # see [BCrypt Homepage](http://bcrypt-ruby.rubyforge.org/)
  # @return [String] the crypted password string
  def password
     @password ||= Password.new(password_digest)
  end

  # Set new crypted password
  # @param [String] new_password (plain text)
  def password= new_password
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  # @param [String] _password (plain-text)
  # @return [Boolean] true if plain-text matches crypted password
  # see [BCrypt Homepage](http://bcrypt-ruby.rubyforge.org/)
  def authenticate _password
    self.password == _password
  end

end
