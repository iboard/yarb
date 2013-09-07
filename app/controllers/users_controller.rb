# -*- encoding : utf-8 -*-"

# Show and edit User's profile
class UsersController < ApplicationController

  before_filter :load_resource
  before_filter :authenticate_user
  helper_method :allow_edit_user?

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

  # @param [User] user - is this user allowed to edit the profile?
  # @return [Boolean] true if current user or admin
  def allow_edit_user? user
    user.id == current_user.id || current_user.has_role?(:admin)
  end

  def change_password
    ChangePasswordService.new(self, @user, params[:user] ) and @user.save
  end

  def user_update_params
    { name:  params[:user].fetch(:name) { @user.name}, email: params[:user].fetch(:email) { @user.email } }
  end

  def authenticate_user
    redirect_back_or_to root_path, notice: t(:access_denied) unless allow_edit_user?(@user)
  end

  def load_resource
    @user = User.find( params[:id] )
  end
end
