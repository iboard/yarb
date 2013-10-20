# -*- encoding : utf-8 -*-"


# EmailConfirmations generates a random token for a user and email
# When confirmed! the attribute confirmed_at is set to now.
class EmailConfirmation
  include Persistable

  key_method :token
  attribute  :token, unique: true
  attribute  :email, unique: true
  attribute  :user_id, unique: true
  attribute  :confirmed_at, type: Time

  # @param [Hash] args
  # @option args [String] :email
  # @option args [String] :token
  def initialize args={}
    set_attributes args
  end


  # Sets the EmailConfirmation to be confirmed
  def confirm!
    self.confirmed_at = Time.now
    save
  end

  # @return [Boolean] true if confirmed_at is set
  def confirmed?
    !self.confirmed_at.nil?
  end

end
