# -*- encoding : utf-8 -*-

# Helper methods for views involved in PagesController
module PagesHelper

  # Add the .sortable-class and action if user granted to sort pages
  # @return [String] css-classes which will install sortable if allowed to sort
  def page_list_css_sort_options
    {
      class: "item-list big top-bordered #{allow_page_sort_class}", 
      action: 'pages/update_order'
    }
  end

  private

  def allow_page_sort_class
    has_roles?(PagesController::PAGE_EDITOR_ROLES) ? 'sortable' : ''
  end


end
