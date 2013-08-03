# The Rails Controller for model Page
class PagesController < ApplicationController

  rescue_from PageNotFoundError, with: :render_not_found

  before_filter :load_md_files
  
  # GET /pages
  def index
    @pages = Page.all
  end

  # GET /pages/:id
  def show
    @page = Page.find params[:id]
    raise PageNotFoundError.new(params[:id]) unless @page
  end


  private
  def load_md_files
    Dir[File.join(Rails.root,'*.md')].each do |file|
      Page.create( title: File.basename(file, '.md').upcase, body: File.read(file))
    end
  end

  def render_not_found
    flash[:alert]=t(:page_does_not_exists, title: params[:id])
    @pages = Page.all
    render :index, status: :not_found
  end
end
