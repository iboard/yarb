# -*- encoding : utf-8 -*-"

require 'bcrypt'

# Identity belongs to an Authentication and stores the password_digest
class Identity
  include Persistable
  include BCrypt

  case STORE_GATEWAY
  when :store
    key_method :authentication_id
    attribute  :authentication_id, unique: true
    attribute  :password_digest
  when :mongoid
    field :authentication_id, type: String
    #validates_presence_of :authentication_id
    #validates_uniqueness_of :authentication_id
    field :password_digest
    field :_id, type: String, default: -> { authentication_id }
    def after_save
      true
    end
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
    self.password_digest= @password.to_s
    self.save
  end

  # @param [String] _password (plain-text)
  # @return [Boolean] true if plain-text matches crypted password
  # see [BCrypt Homepage](http://bcrypt-ruby.rubyforge.org/)
  def authenticate _password
    self.password == _password
  end

  # Virtual Attribute
  # NOOP
  def old_password
  end

  # Virtual Attribute
  # NOOP
  def old_password= _
  end

  # Virtual Attribute
  # NOOP
  def password_confirmation
  end

  # Virtual Attribute
  # NOOP
  def password_confirmation= _
  end
end

