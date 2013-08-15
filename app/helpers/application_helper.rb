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
    if object.errors.any?
      alert_box do
        object.errors.map do |tag, error|
          content_tag :li, class: 'error-entry' do
            content_tag(:strong, tag.to_s) +': '+ content_tag(:span, error.to_s)
          end
        end
        .join("\n").html_safe
      end
    end
  end

  # @param [Symbol|String] symbol - the twitter-bootstrap icon-class
  # @return [String] html-safe string representing twitter-bootstrap-code for the icon
  def icon symbol
    "<i class='#{symbol.to_s}'></i>&nbsp;".html_safe
  end

  private

  def alert_box &block
    content_tag :div, class: 'alert alert-error' do
      content_tag :ul, class: 'error-list' do
        yield
      end
    end
  end

end
