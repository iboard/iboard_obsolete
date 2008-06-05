class PagesController < ApplicationController
  
  before_filter :authenticate, :except => [:show,:show_page,:not_found]
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end
  
  # GET /pages/1/show_page
  # Render a page with it's columns
  # If no page-id is given the first page of the selected language will be displayed
  def show_page
    params[:id] ||= get_language_fisrt_page
    layout = params[:layout] || 'application'
    layout = 'application' if layout.empty?
    begin
      @page = Page.load_with_columns(params[:id])
      l = DivTag.find(@page.div_tag_id).name
      ln =  "#{RAILS_ROOT}/app/views/layouts/#{l}.html.erb"
      if File.exists? "#{RAILS_ROOT}/app/views/layouts/#{l}.html.erb"
        layout = l
      end
    rescue
      flash[:error] = _('ERROR: No Page found in %{file}, line %{line}') % { :file => __FILE__, :line => __LINE__ }
      text =  _('Page %s not found.') % params[:id]
      if granted_for? 'content'
        text += "<a href=#{new_page_path}>" + _('Create a new page') + "</a>"
      end
      render :text => text, :layout => layout
      return true
    end
    
    # check access
    if @page.restrict_to_function_id && (DivTag.find_by_name(layout) == nil )
      if not granted_for? Function.find(@page.restrict_to_function_id).name
        text = _('Sorry, access to the addressed page is restricted.') +
                        "<br/>#{@page.restrict_to_function_id}"
        render :text => text, :layout => layout
      end
    end
    
   render :layout => layout
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = _('Page was successfully created.')
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = _('Page was successfully updated.')
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
  
  # ADD_COLUMN /page/1
  def add_column
    @page = Page.find(params[:id])
    flash.now[:notice] = _('Please choose a column to add')
  end
  
  def add_existing_column
    @page = Page.find(params[:id])
    column = PageColumn.find(params[:page_column_id])
    @page.page_columns << column
    redirect_to show_page_page_path(@page)
  end
  
  def add_new_column
    @page = Page.find(params[:id])
    column = PageColumn.create(  :title => _('New Column for page %s') % @page.name, :div_tag_id => 1 )
    @page.page_columns << column
    redirect_to edit_columns_page_path(@page)
  end
  
  # EDIT_COLUMNS /page/1
  def edit_columns
    @page = Page.load_with_columns(params[:id])
  end
  
  # SAVE_COLUMNS /page/1
  def save_columns
    @page = Page.find(params[:id])
    @page.page_columns.each do |c|
      c.position   = params['positions'][c.id.to_s].to_i
      c.div_tag_id = params['div_tags'][c.id.to_s].to_i
      c.title      = params['titles'][c.id.to_s]
      c.default_order      = params['default_order'][c.id.to_s]
      c.save!
    end
    flash[:notice] = _('Changes saved')
    redirect_to :action => :show_page, :id => @page
  end
  
  # REMOVE_COLUMN /page/1?page_column_id=1
  def remove_column
    @page = Page.find(params[:id])
    column = PageColumn.find(params[:page_column_id])
    @page.page_columns.delete(column)
    flash[:notice] = _('Column removed from this page')
    redirect_to  :action => :show_page, :id => @page
  end
  
  def page_columns
    @columns = PageColumn.find(:all,:order => 'title')
  end
  
  def delete_column
    @column = PageColumn.find(params[:id])
    if @column.postings.length > 0
      flash[:error] = _('You can\'t destroy columns which still contains postings!')
    else
      flash[:notice] = _('Column %s deleted') % @column.title
      @column.destroy
    end
    redirect_to :action => 'page_columns'
  end

  def not_found
    flash[:error] = _('<b>ERROR 404</b>: Sorry, the page you\'ve requested (%s) was not found.<br/>') %
                    request.env['REQUEST_URI']
    redirect_to postings_path
  end
  

  
  private
  def get_language_fisrt_page
    id = Page.find(:first, :conditions => ['language = ?', get_language_code ])
    id || 1
  end
  
end
