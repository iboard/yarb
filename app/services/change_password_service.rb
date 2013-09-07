# -*- encoding : utf-8 -*-"

# Change the password of a user with
# given :old_password, :new_password, and :password_confirmation
class ChangePasswordService

  attr_reader :user

  # Initialize the Service or return true if no params given
  # @param [ActionView|ActionController] view
  # @param [User] user to change password for
  # @param [Hash] params
  def self.new view, user, params
    return true unless password_change_params_present?(params)
    service = super
    service.valid? ? service : false
  end

  def initialize view, user, params
    @view = view
    @user = user
    @params = params
  end

  # @return [Boolean] true if ok. Otherwise false and add errors to # user.
  def valid?
    user.password=@params[:new_password] if params_valid?
  end

  private
  def self.password_change_params_present? _params
    [:old_password, :new_password, :password_confirmation].all? do |param|
      _params[param].present?
    end
  end

  def params_valid?
    unless user.authenticate @params[:old_password]
      user.errors.add(:old_password, :invalid_old_password)
      return false
    end

    unless @params[:new_password] == @params[:password_confirmation]
      user.errors.add(:password_confirmation, :confirmation_does_not_match)
      return false
    end

    if @params[:new_password].length < SignUpService::PASSWORD_MIN_LENGTH
      user.errors.add(:new_password, @view.t("sign_up.password_to_short", min: SignUpService::PASSWORD_MIN_LENGTH))
      return false
    end

    true
  end

end
