class PostingsController < ApplicationController
  
  before_filter :authenticate, :except => [:index, :show, :add, :edit, :create, :new, :destroy]
  
  
  # GET /postings
  # GET /postings.xml
  def index
    date_exp = Date.today()
    if params[:expires] && params[:expires] == "0"
      date_exp = Date::parse("1964-08-31")
    end
        
    params[:search_txt] ||= ''
    
    @postings = Posting.search(params[:search_txt], date_exp, params[:page])

    if params[:observer] == "1"
      params[:observer] = "0"
      render :layout => false
      return
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postings }
    end
  end

  # GET /postings/1
  # GET /postings/1.xml
  def show
    @posting = Posting.find(params[:id])

    layout = params[:layout] || 'application'
    layout = 'application' if layout.empty?
    
    if params[:page_id]
       @page = Page.find(params[:page_id].to_i)
       l = DivTag.find(@page.div_tag_id).name
       ln =  "#{RAILS_ROOT}/app/views/layouts/#{l}.html.erb"
       if File.exists? "#{RAILS_ROOT}/app/views/layouts/#{l}.html.erb"
          layout = l
       end
    end

    respond_to do |format|
      format.html { render :layout => layout }
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = Posting.new
    @posting.date_expires = Date::today()+1.year
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
    if params[:auto_add_to_column]
      @column = PageColumn.find(params[:auto_add_to_column])
    end
    if not @posting.editable_by_user?(user)
      access_denied( @posting )
    end
  end

  # POST /postings
  # POST /postings.xml
  def create
    @posting = Posting.new(params[:posting])

    @column = nil
    if params[:auto_add_to_column]
        @column = PageColumn.find(params[:auto_add_to_column].to_i)
    end

    respond_to do |format|
      if @posting.save
        flash[:notice] = _('Posting was successfully created.')
        if @column
          @column.postings << @posting
          flash[:notice] += _('Posting appended to <b>%s</b>') % @column.title
          if ( @column.page )
            redirect_to( show_page_page_path(@column.page))
          else
            redirect_to( edit_posting_path(@posting)) 
          end
          return
        end
        format.html { redirect_to( edit_posting_path(@posting)) }
        format.xml  { render :xml => @posting, :status => :created, :location => @posting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /postings/1
  # PUT /postings/1.xml
  def update
    @posting = Posting.find(params[:id])
    params[:posting][:page_column_ids] ||= []
    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        flash[:notice] = _('Posting was successfully updated.')
        format.html { redirect_to( edit_posting_path(@posting)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.xml
  def destroy
    @posting = Posting.find(params[:id])
    if @posting.editable_by_user?(user)
      @posting.page_columns.each do |col|
        col.postings.delete @posting
      end
      @posting.destroy
  
      respond_to do |format|
        format.html { if params[:page_id]
                        flash[:notice] = _('Posting deleted')
                        redirect_to(show_page_page_url(params[:page_id]))
                      else
                        redirect_to(postings_url) 
                      end
                    }
                        
        format.xml  { head :ok }
      end
    else
      access_denied(@posting)
    end
  end
  
  def set_order
    @column = PageColumn.find(params[:page_column_id], :include => :postings, :order => 'postings.position' )
    render :layout => false
  end
  
  def update_positions
    params[:sortable_list].each_with_index do |id, position|
      Posting.update(id, :position => position)
    end
    render :nothing => true
  end

  def add
    if granted_for? 'new posting'
      @column = PageColumn.find(params[:page_column_id])
      @posting = Posting.new
      @posting.date_expires = Date::today()+1.year
      render :action => 'new'
    else
      access_denied( session['initial_uri'])
    end
  end

end
