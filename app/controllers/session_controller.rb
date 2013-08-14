class SessionController < ApplicationController

  class User < Struct.new(:email,:name)
    def self.find_by field, value
      return User.new value, 'Testuser'
    end
    def authenticate password
      password == 'secret'
    end
  end

  # GET /sign_in
  def new
  end

  # POST /sign_in
  def create
    user = User.find_by( :email, params[:email] )
    if user.authenticate params[:password]
      redirect_to root_path, notice: t(:successfully_logged_in_as, user: user.name).html_safe
    else
      flash.now[:error] = t(:invalid_credentials)
      render :new
    end
  end

end
