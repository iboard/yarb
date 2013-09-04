# -*- encoding : utf-8 -*-"


# Sign Up A New User
class SignUpController < ApplicationController

  # GET /sign_up
  def new
    @sign_up = SignUp.new
  end

  # POST /sign_up
  def create
    @sign_up = SignUp.new params[:sign_up]
    _service = SignUpService.new @sign_up, self
    if _service.create_user
      redirect_to sign_in_path,
        notice: t("sign_up.successfully_created", email: params[:sign_up][:email])
    else
      render :new
    end
  end
end

