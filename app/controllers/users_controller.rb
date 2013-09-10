# -*- encoding : utf-8 -*-"

# Show and edit User's profile
class UsersController < ApplicationController

  before_filter :load_resource,     except: [:index]
  before_filter :authenticate_user, except: [:index]
  helper_method :allow_edit_user?

  # GET /users
  def index
    if !current_user.has_role?( :admin )
      redirect_back_or_to root_path, status: 404
    else
      @users = User.asc(:name)
    end
  end

  # GET /users/:id
  def show
  end

  # GET /users/:id/edit
  def edit
  end

  # PUT /users/:id
  def update
    if @user.update_attributes( user_update_params ) && change_password
      redirect_to @user, notice: t("user.successfully_updated", email: @user.email)
    else
      render :edit
    end
  end

  private

  def allow_edit_user? user
    user.id == current_user.id || current_user.has_role?(:admin)
  end

  def change_password
    ChangePasswordService.new(self, @user, params[:user] ) and @user.save
  end

  def user_update_params
    { name: name_param , email: email_param }
  end

  def name_param
    params[:user].fetch(:name)  { @user.name}
  end

  def email_param
    params[:user].fetch(:email) { @user.email }
  end

  def authenticate_user
    redirect_back_or_to root_path, notice: t(:access_denied) unless allow_edit_user?(@user)
  end

  def load_resource
    @user = User.find( params[:id] )
  end
end
