# The Rails Controller for model Page
class PagesController < ApplicationController
  
  # GET /pages
  def index
    @pages = Page.all
  end

end
