class CollectorEntriesController < ApplicationController

  layout :get_application_layout
  before_filter :authenticate


  # GET /collector_entries
  # GET /collector_entries.xml
  def index
    if granted_for?('collectors')
      @collector_entries = CollectorEntry.find(:all)
    else
      @collector_entries = CollectorEntry.find_all_by_user_id(user.id)
    end  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @collector_entries }
      format.csv  { render :csv => @collector_entries, :layout => false }
    end
  end

  # GET /collector_entries/1
  # GET /collector_entries/1.xml
  def show
    @collector_entry = CollectorEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @collector_entry }
    end
  end

  # GET /collector_entries/new
  # GET /collector_entries/new.xml
  def new
    @collector_entry = CollectorEntry.new
    @collector_entry.user_id = user.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @collector_entry }
    end
  end

  # GET /collector_entries/1/edit
  def edit
    @collector_entry = CollectorEntry.find(params[:id])
  end

  # POST /collector_entries
  # POST /collector_entries.xml
  def create
    
    @collector_entry = CollectorEntry.new(params[:collector_entry])
    @collector_entry.values = params[:fields].to_xml
    @collector_entry.user_id = user.id
    
    respond_to do |format|
      if @collector_entry.save
        flash[:notice] = 'CollectorEntry was successfully created.'
        format.html { redirect_to collector_entries_path }
        format.xml  { render :xml => @collector_entry, :status => :created, :location => @collector_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @collector_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /collector_entries/1
  # PUT /collector_entries/1.xml
  def update
    @collector_entry = CollectorEntry.find(params[:id])
    @collector_entry.user_id = user.id
    @collector_entry.values = params[:fields].to_xml


    
    respond_to do |format|
      if @collector_entry.update_attributes(params[:collector_entry])
        @collector_entry.values = params[:fields].to_xml
        @collector_entry.save
        flash[:notice] = 'CollectorEntry was successfully updated.'
        format.html { redirect_to collector_entries_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @collector_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /collector_entries/1
  # DELETE /collector_entries/1.xml
  def destroy
    @collector_entry = CollectorEntry.find(params[:id])
    @collector_entry.destroy

    respond_to do |format|
      format.html { redirect_to(collector_entries_url) }
      format.xml  { head :ok }
    end
  end
    
  def load_fields
    if !params[:collector_id].blank?
      @collector = Collector.find(params[:collector_id].to_i)
      @fields = @collector.fields.split(',')
      @entry = CollectorEntry.find(params[:id]) unless params[:id].blank? || params[:id] == 'undefined'
      if @entry
        v = @entry.values
      else
        v = @fields.map{ |f|  {f => "#{f.upcase}"} }.to_xml
      end
      @values = ActiveResource::Formats::XmlFormat::decode(v)
      render :layout => false
    else
      render :text => 'Please select collector', :layout => false
    end
  end
  
end
