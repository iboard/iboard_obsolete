class PagesController < ApplicationController
  
  before_filter :authenticate, :except => [:show,:show_page,:not_found,:redirect_domain]
  
  layout :get_application_layout
  
  def redirect_domain
    
    if granted_for? "root"
      flash[:notice] = _('Redirected because of the servername %s') % request.env['SERVER_NAME']
    end
    
    case request.env['SERVER_NAME']
    when 'www.thesoundtheatre.at' 
      redirect_to :controller => :events, :action => :calendar, :location => 'soundtheatre'
    when 'www.thesoundtheatre.com'
      redirect_to :controller => :events, :action => :calendar, :location => 'soundtheatre'
    when 'www.thesoundtheatre.eu'
      redirect_to :controller => :events, :action => :calendar, :location => 'soundtheatre'
    else
      if (!request.env['HTTP_REFERER'] || ((request.env['HTTP_REFERER'] && request.env['HTTP_REFERER'].blank?) || 
         (request.env['HTTP_REFERER'].match(/^http:\/\/iboard\.cc*/).blank?))) && request.env['SERVER_NAME'] == 'iboard.cc'
         
        redirect_to "http://iboard.cc/fw/index.html"
      else
        redirect_to :action => :show_page, :id => get_language_fisrt_page
      end
    end
  end
  
  
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

    begin
      @page = Page.load_with_columns(params[:id])
    rescue
      flash[:error] = _('ERROR: No Page found in %{file}, line %{line}') % { :file => __FILE__, :line => __LINE__ }
      text =  _('Page %s not found.') % params[:id]
      if granted_for? 'content'
        text += "<a href=#{new_page_path}>" + _('Create a new page') + "</a>"
      end
      render :text => text, :layout => get_application_layout
      return true
    end
    
    # check access
    if @page.restrict_to_function_id 
      if not granted_for? Function.find(@page.restrict_to_function_id).name
        text = _('Sorry, access to the addressed page is restricted.') +
                        "<br/>#{@page.restrict_to_function_id}"
        render :text => text, :layout => get_application_layout
      end
    end
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
      c.max_postings= params['max_postings'][c.id.to_s]
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
    redirect_to :action => :redirect_domain
  end
  
  def update_positions
    params[:sortable_menu].each_with_index do |id, position|
      Page.update(id, :position => position)
    end
    render :nothing => true
  end
  
  private
  def get_language_fisrt_page
    id = Page.find(:first, :conditions => ['language = ?', get_language_code ])
    id || 1
  end
  
end
