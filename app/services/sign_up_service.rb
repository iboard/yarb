# -*- encoding : utf-8 -*-"

# Try to create a new user and set errors of @sign_up if not possible.
class SignUpService

  # Initialized a new SignUpService instance
  # @param [SignUp] sign_up - the model containing user, password,...
  # @param [ActionController|ActionView] view - used to access I18n
  # @param [Object] _request - http-request logged in admin-email
  # @param [Block] block a block to be executed
  def initialize sign_up, view, _request, &block
    @sign_up = sign_up
    @view = view
    @request = _request
    yield self if block_given?
  end

  # Try to create the user
  # @return [User|nil|false] the just created user or false
  def create_user
    create_valid_user.tap do |_user|
      UserMailer.new_user_signed_up( _user, @request ).deliver
    end
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
