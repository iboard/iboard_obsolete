class CalendarsController < ApplicationController
  # GET /calendars
  # GET /calendars.xml
  layout :get_application_layout

  def inline
     @event_groups = Calendar.find_by_sql( "SELECT DISTINCT event_group FROM calendars")
     
     if params['date_range'].blank?
        @ffrom = Time::now()
        @fto   = @ffrom+1.month
     else
        range = params['date_range']
        @ffrom = Date::civil(range['ffrom(1i)'].to_i,range['ffrom(2i)'].to_i,range['ffrom(3i)'].to_i )
        @fto = Date::civil(range['fto(1i)'].to_i,range['fto(2i)'].to_i,range['fto(3i)'].to_i )
     end
     
     if params['event_group'].blank?
       @selected_group = '%'
     else
       @selected_group = params['event_group']
     end
     
     @events = Calendar.find(:all, :conditions => ['event_group like ? and time_start between ? and ?', 
         @selected_group, @ffrom, @fto], :order => "time_start" ) 
  
  end
  
  def index
    @calendars = Calendar.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.xml
  def show
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.xml
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.xml
  def create
    @calendar = Calendar.new(params[:calendar])

    respond_to do |format|
      if @calendar.save
        flash[:notice] = 'Calendar was successfully created.'
        format.html { redirect_to(@calendar) }
        format.xml  { render :xml => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.xml
  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        flash[:notice] = 'Calendar was successfully updated.'
        format.html { redirect_to(@calendar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.xml
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to(calendars_url) }
      format.xml  { head :ok }
    end
  end
end
