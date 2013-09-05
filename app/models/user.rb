# -*- encoding : utf-8 -*-

require 'bcrypt'

# The User-class
# * uses BCrypt to encrypt passwords
# * key :id is equal to :email but used parameterized by module Store
class User

  include Store
  include Store::Timestamps
  include BCrypt
  include Roles

  key_method :id
  attribute  :email, unique: true
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
    @id ||= "%x-%s" % [ Time.now.to_i, SecureRandom::hex(2) ]
  end

  # see [BCrypt Homepage](http://bcrypt-ruby.rubyforge.org/)
  # @return [String] the crypted password string
  def password
     @password ||= Password.new(password_digest) unless password_digest.nil?
  end

  # Set new crypted password from plain_text parameter.
  # If new_password is nil, a random hex-password will be set.
  # @param [String] new_password (plain text)
  def password= new_password
    new_password ||= SecureRandom::hex(8)
    @password = Password.create new_password
    self.password_digest = @password.to_s
  end

  # @param [String] _password (plain-text)
  # @return [Boolean] true if plain-text matches crypted password
  # see [BCrypt Homepage](http://bcrypt-ruby.rubyforge.org/)
  def authenticate _password
    self.password == _password
  end

end
