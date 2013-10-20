# -*- encoding : utf-8 -*-"

# Confirms EmailConfigurations by token
class EmailConfirmationController < ApplicationController

  # GET /confirm_email:token
  def confirm
    EmailConfirmationController.expire_selector
    confirmation = EmailConfirmation.find_by(:token, params[:token])
    @message = if confirmation
                 confirmation.confirm!
                 t("user.email_confirmed_message")
               else
                 t("user.email_confirmation_failed")
               end
  end
end

