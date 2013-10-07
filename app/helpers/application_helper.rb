# -*- encoding : utf-8 -*-
#
# Define global accessible view-helpers here.
module ApplicationHelper

  # Render markdown-text
  # @param [String] text - Plaintext markdown
  # @return [String] html-formated text
  def markdown(text)
    GitHub::Markdown.to_html(text,:markdown).html_safe
  end

  # Render errors for an ActiveModel object
  # @param [ActiveModel::Model] object
  def render_errors_for object
    render_alert_box_for object if object.errors.any?
  end

  def self.build_sign_up sign_up_params
    if !self.needs_invitation? || self.find_invitation( sign_up_params )
      SignUp.new sign_up_params
    end
  end

  def self.needs_invitation?
    Settings.fetch( :app, :needs_invitation )
  end

  private

  def self.find_invitation _params
    token = _params[:invitation_token].present? ? _params[:invitation_token] : session[:invitation_token]
    SignUpInvitation.find( token )
  end

  def alert_box &block
    content_tag :div, class: 'alert alert-error' do
      content_tag(:ul, class: 'error-list') { yield }
    end
  end

  def render_alert_box_for object
    alert_box do
      object.errors.map { |tag, error|
        error_entry_for(tag,error)
      }.join("\n").html_safe
    end
  end

  def error_entry_for tag, error
    content_tag :li, class: 'error-entry' do
      content_tag(:strong, tag.to_s) +': '+ content_tag(:span, error.to_s)
    end
  end

end
