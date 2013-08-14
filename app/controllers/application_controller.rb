# Global Application Controller.
#   Define all global accessible Controller methods here 
class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Make sure we have a session
  before_filter :init_session

  # accessor for current_user
  helper_method :current_user

  # GET /switch_locale/:locale
  def switch_locale
    I18n.locale = params[:locale].to_sym
    redirect_to root_path
  end

  private 
  def init_session
    session[:id] ||= Time.now.to_i.to_s + SecureRandom.hex(8)
  end

  def current_user
    OpenStruct.new( name: 'Testuser' ) if session[:user_id]
  end

end
