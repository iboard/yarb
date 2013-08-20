# -*- encoding : utf-8 -*-

# Global Application Controller.
#   Define all global accessible Controller methods here 
class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Make sure we have a session
  before_filter :init_session

  # Set the locale from session if possible
  before_filter :set_locale

  # get the current user which maybe a NilUser-object
  helper_method :current_user

  # Is someone currently signed in?
  helper_method :signed_in?

  # has the current user some roles?
  helper_method :has_roles?


  # GET /switch_locale/:locale
  def switch_locale
    set_locale_from_param if params[:locale].present?
    redirect_back_or_to root_path
  end

  # @return [Boolean] if current_user is logged ins
  def signed_in?
    @_signed_in ||= real_user?
  end

  # If we have a REFERRER redirect :back otherwise to the given path
  # @param [Array] args the args passed to redirect_to
  def redirect_back_or_to *args
    path = args.shift
    redirect_to (can_go_back? ? :back : path), *args
  end

  private 

  def set_locale_from_param
    I18n.locale = session[:locale] = params[:locale].to_sym
  end

  def can_go_back?
    @_can_go_back ||= request.env['HTTP_REFERER'].present?
  end

  def init_session
    session[:session_started_at] ||= Time.now
  end

  def current_user
    @_current_user ||= user_from_session || NilUser.new
  end

  def real_user?
    !current_user.is_a?(NilUser)
  end

  def user_from_session
    User.find_by(:id, session[:user_id]) if session[:user_id].present?
  end

  def has_roles? roles
    roles.any? { |role| current_user.has_role? role }
  end

  def set_locale
    unless params[:locale].present?
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end

end
