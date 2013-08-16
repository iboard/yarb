# Global Application Controller.
#   Define all global accessible Controller methods here 
class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Make sure we have a session
  before_filter :init_session
  before_filter :set_locale

  helper_method :current_user
  helper_method :signed_in?

  helper_method :has_roles?
  # GET /switch_locale/:locale
  def switch_locale
    I18n.locale = params[:locale].to_sym
    session[:locale] = params[:locale].to_sym
    if request.env['HTTP_REFERER'].present?
      redirect_to :back 
    else
      redirect_to root_path
    end
  end

  private 
  def init_session
    session[:id] ||= Time.now.to_i.to_s + SecureRandom.hex(8)
  end

  def current_user
    return NilUser.new unless session[:user_id]
    User.find_by :id, session[:user_id] || NilUser.new
  end

  def has_roles? roles
    roles.any? do |role|
      current_user.has_role? role
    end
  end

  def set_locale
    unless params[:locale]
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end

  def signed_in?
    !current_user.is_a?(NilUser)
  end

end
