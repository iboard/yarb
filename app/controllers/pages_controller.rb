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
  helper_method :is_page_editor?

  # Roles which can delete pages
  # ruby 2.0 only #PAGE_TERMINATOR_ROLES  = %i( admin maintainer )
  PAGE_TERMINATOR_ROLES  = [ :admin, :maintainer ]

  # Catch 404 errors
  rescue_from PageNotFoundError, with: :render_not_found

  # Loading all *.md-files from project's root into Page-store
  before_filter :refresh_md_files

  # Load @page if param :id is present
  before_filter :load_resource

  # Invalidate Cache
  before_filter :expire_selection

  # Redirect with access denied if action is not allowed
  before_filter :authorize_creators, only: [ :new, :create ]
  before_filter :authorize_editors,  only: [ :edit, :update, :update_order ]
  before_filter :authorize_terminators, only: [ :destroy ]

  # GET /pages
  def index
    @pages = visible_pages.all
  end

  # GET /pages/:id
  # @raise [PageNotFoundError] if page doesn't exist
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # POST /pages/create
  def create
    @page = Page.create( params[:page] )
    if @page.valid?
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


  # Update Sort Order
  # POST /pages/update_order
  def update_order
    update_positions params[:sorted_ids]
    render nothing: true
  end


  private

  def visible_pages
    is_page_editor? ? Page : Page.where( draft: false )
  end

  def is_page_editor?
    has_roles?(PagesController::PAGE_EDITOR_ROLES)
  end

  def update_positions ordered_ids
    ordered_ids.each_with_index do |id, idx|
      Page.find_and_update_attributes(id.gsub(/^page-/,''), { position:  idx+1 })
    end
  end

  def refresh_md_files
    Dir[md_files_wildcards].each do |file|
      StaticPageUpdateService.new file
    end
  end

  def md_files_wildcards
    File.join(Rails.root,'*.md')
  end

  def render_not_found
    flash[:alert]=t(:page_does_not_exists, title: params[:id])
    @pages = visible_pages.all
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
    if params[:id].present?
      @page ||= visible_pages.find(params[:id])
      raise PageNotFoundError.new(params[:id]) unless @page
    end
  end

  def expire_selection
    Page.expire_selector
  end
end
