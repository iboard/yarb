# -*- encoding : utf-8 -*-
#
require "oauth_sign_up"

# The SessionController handles log-in and log-out
# by setting a valid's user-id to session[:user_id]
class SessionController < ApplicationController

  # GET /sign_in
  def new
  end

  # POST /sign_in
  def create
    if @auth = request.env["omniauth.auth"]
      user = AuthenticationService.new(self,@auth).user
      if user && user.valid?
        session[:user_id] = user.id
        redirect_to root_path, notice: t("successfully_logged_in_as", user: user.name).html_safe
      else
        user.delete if user
        @sign_up = OAuthSignUp.new(@auth)
        render :complete_auth
      end
    else
      email, password = extract_params(params["/sign_in"])
      user = User.find_by( :email, email ) || NilUser.new
      authenticate_and_redirect(user, password)
    end
  end

  # POST /sign_up/complete_auth
  def complete_auth
    email=params[:o_auth_sign_up][:email]
    name=params[:o_auth_sign_up][:name]
    provider=params[:o_auth_sign_up][:provider]
    uid=params[:o_auth_sign_up][:uid]

    user = User.create! email: email, name: name
    user.authentication.delete
    authentication = Authentication.create! provider: provider, uid: uid, user_id: user.id
    session[:user_id] = user.id
    redirect_to root_path,
      notice: t(:successfully_logged_in_as, user: user.name).html_safe
  end

  # DELETE /sign_out
  def delete
    session.destroy
    redirect_to root_path, notice: t(:successfully_signed_out)
  end


  # GET /auth/failure?message=invalid_credentials
  def failure
    flash[:alert]=t("sign_in_view.oauth_failed", message: t(params[:message].to_sym)).html_safe
    render :new, status: :unauthorized
  end

  private

  def extract_params _params
    [ _params.fetch(:email), _params.fetch(:password) ]
  end

  def authenticate_and_redirect(user, password)
    if user.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_path,
        notice: t(:successfully_logged_in_as, user: user.name).html_safe
    else
      flash.now[:error] = t(:invalid_credentials)
      render :new
    end
  rescue
    flash.now[:error] = t(:invalid_credentials)
    render :new
  end

end
