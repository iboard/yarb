# -*- encoding : utf-8 -*-"

# Find or create a User by their Authentication
class AuthenticationService

  attr_reader :user

  def initialize controller, auth
    @controller = controller
    @auth = auth
    @user = find_or_create_user_from_auth(auth)
  end

  # @param [Hash] auth OmniAuth-authentication-hash
  # @return [User]
  def find_or_create_user_from_auth auth
    authentication = Authentication.where( provider: auth[:provider], uid: auth[:uid] ).all.first
    if authentication
      User.find( authentication.user_id )
    else
      create_from_auth(auth)
    end
  end

  private

  def create_from_auth auth
    User.create_from_auth auth
  end

end
