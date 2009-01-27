class CollectorsController < ApplicationController
  layout :get_application_layout
  before_filter :authenticate
    
  # GET /collectors
  # GET /collectors.xml
  def index
    @collectors = Collector.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @collectors }
    end
  end

  # GET /collectors/1
  # GET /collectors/1.xml
  def show
    @collector = Collector.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @collector }
    end
  end

  # GET /collectors/new
  # GET /collectors/new.xml
  def new
    @collector = Collector.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @collector }
    end
  end

  # GET /collectors/1/edit
  def edit
    @collector = Collector.find(params[:id])
  end

  # POST /collectors
  # POST /collectors.xml
  def create
    @collector = Collector.new(params[:collector])

    respond_to do |format|
      if @collector.save
        flash[:notice] = 'Collector was successfully created.'
        format.html { redirect_to(@collector) }
        format.xml  { render :xml => @collector, :status => :created, :location => @collector }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @collector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /collectors/1
  # PUT /collectors/1.xml
  def update
    @collector = Collector.find(params[:id])

    respond_to do |format|
      if @collector.update_attributes(params[:collector])
        flash[:notice] = 'Collector was successfully updated.'
        format.html { redirect_to(@collector) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @collector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /collectors/1
  # DELETE /collectors/1.xml
  def destroy
    @collector = Collector.find(params[:id])
    @collector.destroy

    respond_to do |format|
      format.html { redirect_to(collectors_url) }
      format.xml  { head :ok }
    end
  end
  
end
