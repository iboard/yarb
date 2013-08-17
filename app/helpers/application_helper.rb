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

  # @param [Symbol|String] symbol - the twitter-bootstrap icon-class(es)
  # @return [String] html-safe string representing twitter-bootstrap-code for the icon
  def icon symbol
    "<i class='#{symbol.to_s}'></i>&nbsp;".html_safe
  end

  # @param [Symbol|String] symbol - the twitter-bootstrap icon-class(es)
  # @param [String] text - the text to be displayed after the icon
  # @return [String] html-safe string representing twitter-bootstrap-code for the icon
  def icon_with_text symbol, text
    icon(symbol) + "&nbsp;".html_safe + text
  end

  # Insert a delete-button with data-confirm
  # @param [String] path
  # @return [String] html
  def delete_link_tag path
    link_to icon_with_text('icon-trash icon-white',t(:delete)), path, 
      method: :delete, 
      data: { confirm: t(:are_you_sure) }, 
      class: 'btn btn-danger'
  end

  # Insert a 'green' button with a +-sign
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def new_button_tag label, path
    link_to icon_with_text('icon-plus-sign icon-white',label), path, class: 'btn btn-success'
  end

  # Insert a 'default' button with a list-sign
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def list_button_tag label, path
    link_to icon_with_text('icon-list',label), path, class: 'btn btn-default'
  end

  # @param [Symbol] locale
  # @return [String] html-link
  def switch_to_locale_path_link locale
    link_to t(locale.to_sym), switch_locale_path(locale) 
  end

  private

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
