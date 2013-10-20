# -*- encoding : utf-8 -*-
#
# Used when otherwise no user would exist.
# Used especially instead of `if current_user`
class NilUser

  attr_reader  :id, :email, :name, :password_digest, :roles

  def initialize args={}
    @name = '(no name)'
    @roles = []
  end

  # @return [nil]
  def password
  end

  # No op, you may pass in whatever you want
  def password= new_password
  end

  # @param [Object] _password (doesn't matter)
  # @return false no matter what _password is.
  def authenticate _password
    false
  end

  # @param [Object] _ (doesn't matter)
  # @return false no matter what _role is
  def has_role? _
    false
  end



end
