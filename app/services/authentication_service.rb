# -*- encoding : utf-8 -*-"

# Find or create a User by their Authentication
class AuthenticationService

  attr_reader :user

  # Initializer
  # @param [ActionController] controller the controller
  # @param [Authentication] auth Authentication object
  # @param [Hash] _session the session Hash
  # @return [AuthenticationService]
  def initialize controller, auth, _session={}
    @controller = controller
    @auth = auth
    @session = _session
    @user = find_or_create_user_from_auth(auth)
  end

  private

  def find_or_create_user_from_auth auth
    authentication = Authentication.where( provider: auth[:provider], uid: auth[:uid] ).all.first
    if authentication
      User.find( authentication.user_id )
    else
      create_from_auth(auth)
    end
  end

  def create_from_auth auth
    if !ApplicationHelper.needs_invitation? || ApplicationHelper.find_invitation(@session)
      User.create_from_auth auth
    end
  end

end
