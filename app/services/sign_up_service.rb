# -*- encoding : utf-8 -*-"

# Try to create a new user and set errors of @sign_up if not possible.
class SignUpService

  # Sets the minimum length of password for sign_up and change_password.
  PASSWORD_MIN_LENGTH = 4

  # @param [SignUp] sign_up - the model containing user, password,...
  # @param [ActionController|ActionView] view - used to access I18n
  def initialize sign_up, view
    @sign_up = sign_up
    @view = view
  end

  # Try to create the user
  # @return [User|nil|false] the just created user or false
  def create_user
    create_valid_user
  end

  private

  def create_valid_user
    return unless check_name && check_existing_users && check_password_length
    if check_confirmation
      _user = User.create email: @sign_up.email, name: @sign_up.name
      _user.password = @sign_up.password
      _user.save
    end
  end

  def check_name
    if @sign_up.name.length > 0
      true
    else
      @sign_up.errors.add(:name, @view.t("sign_up.name_cant_be_blank"))
      false
    end
  end

  def check_existing_users
    if User.find_by :email, @sign_up.email
      @sign_up.errors.add( :email, @view.t("sign_up.email_exists") )
      false
    else
      true
    end
  end

  def check_confirmation
    if @sign_up.password == @sign_up.password_confirmation
      true
    else
      @sign_up.errors.add( :password_confirmation,
                          @view.t("sign_up.confirmation_does_not_match" )
                         )
      false
    end
  end

  def check_password_length
    if @sign_up.password.length < 5
      @sign_up.errors.add( :password, @view.t("sign_up.password_to_short", min: PASSWORD_MIN_LENGTH ))
      return false
    else
      true
    end
  end


end
