class AccessorsController < ApplicationController
  
  before_filter :authenticate
  
  # GET /accessors
  # GET /accessors.xml
  def index
    @accessors = Accessor.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accessors }
    end
  end

  # GET /accessors/1
  # GET /accessors/1.xml
  def show
    @accessor = Accessor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accessor }
    end
  end

  # GET /accessors/new
  # GET /accessors/new.xml
  def new
    @accessor = Accessor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accessor }
    end
  end

  # GET /accessors/1/edit
  def edit
    @accessor = Accessor.find(params[:id])
  end

  # POST /accessors
  # POST /accessors.xml
  def create
    @accessor = Accessor.new(params[:accessor])

    respond_to do |format|
      if @accessor.save
        flash[:notice] = _('Accessor was successfully created.')
        format.html { redirect_to(@accessor) }
        format.xml  { render :xml => @accessor, :status => :created, :location => @accessor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accessor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accessors/1
  # PUT /accessors/1.xml
  def update
    @accessor = Accessor.find(params[:id])

    respond_to do |format|
      if @accessor.update_attributes(params[:accessor])
        flash[:notice] = _('Accessor was successfully updated.')
        format.html { redirect_to(@accessor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accessor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accessors/1
  # DELETE /accessors/1.xml
  def destroy
    @accessor = Accessor.find(params[:id])
    @accessor.destroy

    respond_to do |format|
      format.html { redirect_to(accessors_url) }
      format.xml  { head :ok }
    end
  end
end
