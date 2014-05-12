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
      create_with_omniauth
    else
      create_with_identity
    end
  end

  # POST /sign_up/complete_auth
  def complete_auth
    user = create_and_sign_in_user_with_authentication
    if user
      redirect_to root_path,
        notice: t(:successfully_logged_in_as, user: user.name).html_safe
    else
      redirect_to root_path, alert: t("sign_up.can_not_create_user")
    end
  end


  # DELETE /sign_out
  def delete
    session.destroy
    redirect_to root_path, notice: t(:successfully_signed_out)
  end


  # GET /auth/failure?message=invalid_credentials
  def failure
    flash[:alert] = t("sign_in_view.oauth_failed",
                      message: t(params[:message].to_sym)
                     ).html_safe
    render :new, status: :unauthorized
  end

  # GET /forgot_password
  def forgot_password
  end

  # POST /reset_password
  def reset_password
    _user = User.find_by(:email, extract_email_from_params(params['/reset_password']))

    if _user
      _user.create_edit_token!
      redirect_to sign_in_path, notice: t('passwort_reset')
    else
      redirect_to sign_in_path, notice: t('passwort_reset')
    end

  end

  private

  def create_with_identity
    email, password = extract_params(params["/sign_in"])
    user = User.find_by( :email, email ) || NilUser.new
    authenticate_and_redirect(user, password)
  end

  def create_with_omniauth
    user = AuthenticationService.new(self,@auth,session).user
    valid_user?(user) ?  created_successfully(user) : create_failed(user)
  end

  def create_failed user
    user.delete if user
    @sign_up = OAuthSignUp.new(@auth,session)
    render :complete_auth
  end

  def created_successfully user
    session[:user_id] = user.id
    redirect_to root_path, notice: t("successfully_logged_in_as", user: user.name).html_safe
  end

  def create_and_sign_in_user_with_authentication
    if allowed_without_or_valid_invitation?
      create_and_sign_in_user *extract_oauth_params(params[:o_auth_sign_up])
    end
  end

  def create_and_sign_in_user email, name, provider, uid
    user = User.create! email: email, name: name
    user.recreate_authentication provider, uid
    session[:user_id] = user.id
    ApplicationHelper.invitation_service_for(user,params[:o_auth_sign_up])
    user
  end

  def extract_params _params
    [ _params.fetch(:email), _params.fetch(:password) ]
  end

  def extract_email_from_params _params
    _params.fetch(:email)
  end

  def extract_oauth_params hash
    [ hash[:email], hash[:name], hash[:provider], hash[:uid] ]
  end

  def authenticate_and_redirect(user, password)
    user.authenticate(password) ?  assign_session(user) : render_new_with_error
  rescue
    render_new_with_error
  end

  private

  def valid_user? user
    user && user.valid?
  end

  def assign_session user
    session[:user_id] = user.id
    redirect_to root_path,
      notice: t(:successfully_logged_in_as, user: user.name).html_safe
  end

  def render_new_with_error
    flash.now[:error] = t(:invalid_credentials)
    render :new
  end

  def allowed_without_or_valid_invitation?
    !ApplicationHelper.needs_invitation? ||
      ApplicationHelper.find_invitation(params[:o_auth_sign_up])
  end

end
