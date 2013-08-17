# -*- encoding : utf-8 -*-
#
# The Rails Controller for model Page
class PagesController < ApplicationController

  # Roles which can create pages
  # ruby 2.0 only # PAGE_CREATOR_ROLES = %i( admin author editor maintainer )
  PAGE_CREATOR_ROLES = [ :admin, :author, :editor, :maintainer ]

  # Roles which can edit pages
  # ruby 2.0 only #PAGE_EDITOR_ROLES  = %i( admin editor maintainer )
  PAGE_EDITOR_ROLES  = [ :admin, :editor, :maintainer ]

  # Roles which can delete pages
  # ruby 2.0 only #PAGE_TERMINATOR_ROLES  = %i( admin maintainer )
  PAGE_TERMINATOR_ROLES  = [ :admin, :maintainer ]

  rescue_from PageNotFoundError, with: :render_not_found

  # Loading all *.md-files from project's root into Page-store
  before_filter :refresh_md_files

  # Load @page if param :id is present
  before_filter :load_resource

  # Redirect with access denied if action is not allowed
  before_filter :authorize_creators, only: [ :new, :create ]
  before_filter :authorize_editors,  only: [ :edit, :update ]
  before_filter :authorize_terminators, only: [ :destroy ]


  # GET /pages
  def index
    @pages = Page.all
  end

  # GET /pages/:id
  # @raise [PageNotFoundError] if page doesn't exist
  def show
    raise PageNotFoundError.new(params[:id]) unless @page
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # POST /pages/create
  def create
    @page = Page.create( params[:page] )
    if @page.valid_without_errors?
      redirect_to page_path( @page )
    else
      flash.now[:alert]= t(:could_not_be_saved, what: t(:page))
      render :new
    end
  end

  # GET /pages/:id/edit
  def edit
  end

  # PUT /pages/:id
  def update
    if @page.update_attributes( params[:page] )
      redirect_to pages_path, notice: t(:page_successfully_updated)
    else
      render :edit
    end
  end

  # DELETE /pages/:id
  def destroy
    @page.delete 
    redirect_to pages_path, notice: t(:page_deleted, title: @page.title)
  end

  private

  def refresh_md_files
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

  def authorize_creators
    redirect_back_or_to pages_path, alert: t(:access_denied) unless has_roles?( PAGE_CREATOR_ROLES )
  end

  def authorize_editors
    redirect_back_or_to page_path(params[:id]), alert: t(:access_denied) unless has_roles?( PAGE_EDITOR_ROLES )
  end

  def authorize_terminators
    redirect_back_or_to pages_path, alert: t(:access_denied) unless has_roles?( PAGE_TERMINATOR_ROLES )
  end

  def load_resource
    @page ||= Page.find(params[:id]) if params[:id].present?
  end
  
end
