# -*- encoding : utf-8 -*-"

# A non persistent model to collect and validate sign-up information
class SignUp

  # Sets the minimum length of password for sign_up and change_password.
  PASSWORD_MIN_LENGTH = 4

  include  ActiveModel::Model
  extend   ActiveModel::Naming
  attr_accessor :name, :email, :password, :password_confirmation, :invitation_token
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation

  # Initialize SignUp with params from the sign-up form.
  # @param [Hash] _args (default {})
  # @option _args [String] :name - Name of the user
  # @option _args [String] :email - Users email-address
  # @option _args [String] :password
  # @option _args [String] :password_confirmation
  def initialize _args={}
    @name = _args.fetch(:name){nil}
    @email = _args.fetch(:email){nil}
    @password = _args.fetch(:password){nil}
    @password_confirmation = _args.fetch(:password_confirmation){nil}
  end

  # Check and add Errors if not valid.
  # @param [ActiveView|ApplicationController] view - used for I18n
  # @return [Boolean] true if no errors.
  def pre_validate(view)
    @view = view
    check_name && check_existing_users && check_password_length
  end

  # Check if password and password_confirmation match and add error if not.
  # @param [ActiveView|ApplicationController] view - used for I18n
  # @return [Boolean]
  def check_confirmation(view)
    add_error_unless(
      password == password_confirmation,
      :password_confirmation,
      view.t("sign_up.confirmation_does_not_match" )
    )
  end

  private

  def add_error_unless condition, field, message
    errors.add( field, message) unless !!condition
    condition
  end

  def check_name
    add_error_unless name.length > 0, :name, @view.t("sign_up.name_cant_be_blank")
  end

  def check_existing_users
    add_error_unless User.find_by(:email, email).nil?,
      :email, @view.t("sign_up.email_exists")
  end

  def check_password_length
    add_error_unless password.length >= PASSWORD_MIN_LENGTH,
      :password,
      @view.t("sign_up.password_to_short", min: PASSWORD_MIN_LENGTH )
  end

end
