# The SessionController handles log-in and log-out
# by setting a valid's user-id to session[:user_id]
class SessionController < ApplicationController

  # GET /sign_in
  def new
  end

  # POST /sign_in
  def create
    user = User.find_by( :email, params[:email] ) || NilUser.new
    if user.authenticate(params[:password])
      session[:user_id] = user.email
      redirect_to root_path, notice: t(:successfully_logged_in_as, user: user.name).html_safe
    else
      flash.now[:error] = t(:invalid_credentials)
      render :new
    end
  end

  # DELETE /sign_out
  def delete
    session.destroy
    redirect_to root_path, notice: t(:successfully_signed_out)
  end

end
