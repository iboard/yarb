# -*- encoding : utf-8 -*-"

# Try to create a new user and set errors of @sign_up if not possible.
class SignUpService

  # @param [SignUp] sign_up - the model containing user, password,...
  # @param [ActionController|ActionView] view - used to access I18n
  def initialize sign_up, view, &block
    @sign_up = sign_up
    @view = view
    yield self if block_given?
  end

  # Try to create the user
  # @return [User|nil|false] the just created user or false
  def create_user
    create_valid_user
  end

  private

  def create_valid_user
    if allow_creation? && @sign_up.check_confirmation(@view)
      _user = User.create email: @sign_up.email, name: @sign_up.name
      _user.password = @sign_up.password
      _user.save
    end
  end

  def allow_creation?
    @sign_up.pre_validate(@view)
  end

end
