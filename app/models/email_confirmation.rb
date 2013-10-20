# -*- encoding : utf-8 -*-"


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
  end

end
