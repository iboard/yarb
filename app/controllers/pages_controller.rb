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

  # GET /pages/new
  def new
    @page = Page.new title: ''
  end

  # POST /pages/create
  def create
    @page = Page.create( params[:page] )
    if @page.errors.empty? && @page.valid?
      redirect_to page_path( @page )
    else
      flash.now[:alert]= t(:could_not_be_saved, what: t(:page))
      render :new
    end
  end

  # DELETE /pages/:id
  def destroy
    @page = Page.find( params[:id] )
    @page.delete 
    redirect_to pages_path, notice: t(:page_deleted, title: @page.title)
  end

  private
  def load_md_files
    Dir[File.join(Rails.root,'*.md')].each do |file|
      _title = title_of_md_file file
      page = Page.find(_title) || Page.create( title: _title.upcase )
      page.body = File.read(file)
      page.save
    end
  end

  def title_of_md_file _file
    File.basename(_file, '.md')
  end

  def render_not_found
    flash[:alert]=t(:page_does_not_exists, title: params[:id])
    @pages = Page.all
    render :index, status: :not_found
  end
end
