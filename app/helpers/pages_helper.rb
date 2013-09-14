# -*- encoding : utf-8 -*-

# Helper methods for views involved in PagesController
module PagesHelper

  # Add the .sortable-class and action if user granted to sort pages
  # @return [String] css-classes which will install sortable if allowed to sort
  def page_list_css_sort_options
    sort_classes.merge( editor_actions )
  end

  private

  def sort_classes
    { class: "item-list big top-bordered #{allow_page_sort_class}" }
  end

  def editor_actions
    is_page_editor? ? { action: "pages/update_order" } : {}
  end

  def allow_page_sort_class
    is_page_editor? ? "sortable" : ""
  end

end
