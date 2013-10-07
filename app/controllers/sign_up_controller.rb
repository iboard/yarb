# -*- encoding : utf-8 -*-"


# Sign Up A New User
class SignUpController < ApplicationController

  before_filter :check_invitation, only: [:create]
  helper_method :needs_invitation?

  # GET /sign_up
  def new
    @sign_up = SignUp.new
  end

  # POST /sign_up
  def create
    @sign_up = SignUp.new params[:sign_up]
    SignUpService.new @sign_up, self do |_service|
      if _service.create_user
        redirect_to sign_in_path,
          notice: t("sign_up.successfully_created", email: params[:sign_up][:email])
      else
        render :new
      end
    end
  end

  # GET /sign_up/accept_invitation/:token
  def accept_invitation
    @sign_up = SignUp.new
    @sign_up.invitation_token = params[:token]
    session[:invitation_token] = params[:token]
    render :new
  end

  private

  def needs_invitation?
    ApplicationHelper::needs_invitation?
  end

  def check_invitation
    @sign_up = ApplicationHelper::build_sign_up params[:sign_up]
    unless @sign_up
      flash.now[:alert] = t("sign_up.invitation_token_invalid")
      @sign_up = SignUp.new
      render :new
    end
  end

end

