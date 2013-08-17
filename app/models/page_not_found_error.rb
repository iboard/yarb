# -*- encoding : utf-8 -*-
#
# Thrown when pages-controller couldn't find the page
class PageNotFoundError < Exception

  attr_reader :page_id

  def initialize page_id
    @page_id = page_id
  end

end
