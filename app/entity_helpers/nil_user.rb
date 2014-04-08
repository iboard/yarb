# -*- encoding : utf-8 -*-
#
# Used when otherwise no user would exist.
# Used especially instead of `if current_user`
class NilUser

  attr_reader  :id, :email, :name, :password_digest, :roles

  # Initializer
  # @param [Hash] args argument Hash
  # @return [NilUser]
  def initialize args={}
    @name = '(no name)'
    @roles = []
  end

  # Basically returns nil all the time
  # @return [nil] nothing
  def password
  end

  # No op, you may pass in whatever you want
  # @param [String] _new_password arbitrary String
  def password= _new_password
  end

  # @param [Object] _password (doesn't matter)
  # @return false no matter what _password is.
  def authenticate _password
    false
  end

  # @param [Array] _ (doesn't matter)
  # @return false no matter what _role is
  def has_any_role? _
    false
  end

  # @param [Object] _ (doesn't matter)
  # @return false no matter what _role is
  def has_role? _
    false
  end



end
