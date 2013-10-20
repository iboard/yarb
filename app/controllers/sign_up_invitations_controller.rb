# -*- encoding : utf-8 -*-"

# Send SignUpInvitations
class SignUpInvitationsController < ApplicationController

  before_filter :ensure_admin!

  # GET /sign_up_invitations
  def index
    @sign_up_invitations = SignUpInvitation.all
  end

  # GET /sign_up_invitations/new
  def new
    @sign_up_invitation = build_new_invitation
  end

  # POST /sign_up_invitations
  def create
    @sign_up_invitation = create_invitation
    deliver_valid_invitation(@sign_up_invitation)
  end

  # DELETE /sign_up_invitations/:token
  def destroy
    invitation = SignUpInvitation.find( params[:id] )
    invitation.delete
    redirect_to sign_up_invitations_path, notice: t("sign_up.invitation_rejected")
  end

  private
  def sign_up_params
    receiver = params[:sign_up_invitation][:to]
    message  = params[:sign_up_invitation][:message]
    [receiver, message: message]
  end

  def build_new_invitation
    SignUpInvitation.new(current_user, '', message: '')
  end

  def create_invitation
    invitation = SignUpInvitation.new(current_user, *sign_up_params)
    invitation.save or invitation
  end

  def deliver_valid_invitation(invitation)
    if invitation.valid?
      invitation.deliver
      redirect_to sign_up_invitations_path, notice: t("sign_up.invitation_sent_to", email: invitation.to).html_safe
    else
      render :new
    end
  end

  def ensure_admin!
    redirect_back_or_to root_path, alert: t(:access_denied) unless current_user.has_role?(:admin)
  end

end
