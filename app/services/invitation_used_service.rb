# -*- encoding : utf-8 -*-"

# When a user get's greated using an sign_up_invitation
class InvitationUsedService

  # Deliver mail to invitor informing them about the invitation was used
  # @param [User] _user the user signed up
  # @param [Hash] _params params from sign-up-service
  # @option _params [String] :invitation_token
  def initialize _user, _params
    invitation = find_invitation(_params)
    UserMailer.invitation_used( _user, invitation).deliver if invitation
  end

  private

  def find_invitation params
    SignUpInvitation.find( params[:invitation_token] )
  end
end
