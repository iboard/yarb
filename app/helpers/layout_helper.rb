# some useful functions for views
module LayoutHelper

  # @param [String] concatinator
  # @return [String]
  # @yields [Symbol] locale
  def join_all_locales concatinator, &block
    if block_given?
      I18n.available_locales.map { |locale|
        yield(locale)
      }.join(concatinator).html_safe
    else
      I18n.available_locales.map(&:to_s).join(concatinator).html_safe
    end
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
    link_to icon_with_text('icon-trash icon-white', t(:delete)),
      path,
      method: :delete,
      data: { confirm: t(:are_you_sure) },
      class: 'btn btn-danger'
  end

  # Insert a 'green' button with a +-sign
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def new_button_tag label, path
    link_to icon_with_text('icon-plus-sign icon-white',label),
      path,
      class: 'btn btn-success'
  end

  # Insert a 'default' button with a list-sign
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def list_button_tag label, path
    link_to icon_with_text('icon-list',label),
      path,
      class: 'btn btn-default'
  end

  # Insert a 'primary' button with an edit-icon
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def edit_button_tag label, path
    link_to icon_with_text('icon-edit icon-white',label),
      path,
      class: 'btn btn-primary'
  end

  # Insert a 'default' button with a cancel-sign
  # @param [String] label
  # @param [String] path
  # @return [String] html-link
  def cancel_button_tag label, path
    link_to icon_with_text('icon-remove',label),
      path,
      class: 'btn btn-default'
  end

  # @param [Symbol] locale
  # @return [String] html-link
  def switch_to_locale_path_link locale
    link_to t(locale.to_sym), set_locale_path(locale)
  end

  # @return [String] 'active' if path is current.
  def active_class path
    current_page?(path)  ? 'active' : ''
  end

  # @return [String] css-classes for standard forms
  def standard_form_classes
    'form form-vertical'
  end

  # @return [String] css-classes for standard save-buttons
  def save_button_classes
   'btn btn-primary'
  end

  # @return [String] create_at and updated_at concatinated
  def model_date_information _model
    c,m = _model.created_at, _model.updated_at
    _str = t(:created_at, time: c.to_s(:short))
    _str << ", " << t(:updated_at, time: m.to_s(:short)) unless c == m
  end
end
