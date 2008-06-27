class EventsController < ApplicationController
  
  before_filter :authenticate, :except => [:index,:show,:calendar,:rss]
  layout :get_application_layout
  
  # GET /events
  # GET /events.xml
  def index
    if params[:month]
      month = Date::parse(params[:month])
      conditions = ['begins_at between ? and ?', month, (month+1.month-1.day)]
    else
      if not granted_for? 'events'
        conditions = ['begins_at >= ?', Date::today() ]
      else
        conditions = ['1 = 1' ]
      end
    end
    
    
    
    @events = Event.find(:all, :conditions => conditions, :order => "begins_at" )
    if @events.length < 1
      flash[:error] = _('Sorry, no events found')
    end

    respond_to do |format|
      format.html 
      format.rss 
      format.xml  { render :xml => @events }
    end
  end

  # GET /events
  # GET /events.xml
  def list
    if params[:month]
      month = Date::parse(params[:month])
      conditions = ['begins_at between ? and ?', month, (month+1.month-1.day)]
    else
      conditions = ['begins_at >= ?', Date::today() ]
    end
    
    @events = Event.find(:all, :conditions => conditions, :order => "begins_at" )
    if @events.length < 1
      flash[:error] = _('Sorry, no events found')
    end

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @events }
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def calendar
    @location = params[:location]
    @events = Event.find_all_by_location(@location, :order => 'begins_at asc', 
      :conditions => ['promoted = ? and begins_at >= ?', true, Date::today], :limit => 8 )
  end
  
  def rss
    params[:language] ||= DEFAULT_LANGUAGE
    @events =  Event.find(:all, :order => 'begins_at asc', :conditions => ['begins_at >= ?', Date::today] )
    render :layout => false
  end
  
end
