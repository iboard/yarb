# -*- encoding : utf-8 -*-

# Helper methods for views involved in PagesController
module PagesHelper

  # Add the .sortable-class and action if user granted to sort pages
  # @return [String] css-classes which will install sortable if allowed to sort
  def page_list_css_sort_options
    _options = { class: "item-list big top-bordered #{allow_page_sort_class}" }
    _options[:action] =  "pages/update_order" if is_page_editor?
    _options
  end

  private

  def allow_page_sort_class
    is_page_editor? ? "sortable" : ""
  end

end
