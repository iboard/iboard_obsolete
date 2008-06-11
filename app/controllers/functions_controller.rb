class FunctionsController < ApplicationController
  
  before_filter :authenticate
  layout :get_application_layout
  
  # GET /functions
  # GET /functions.xml
  def index
    @functions = Function.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @functions }
    end
  end

  # GET /functions/1
  # GET /functions/1.xml
  def show
    @function = Function.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @function }
    end
  end

  # GET /functions/new
  # GET /functions/new.xml
  def new
    @function = Function.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @function }
    end
  end

  # GET /functions/1/edit
  def edit
    @function = Function.find(params[:id])
  end

  # POST /functions
  # POST /functions.xml
  def create
    @function = Function.new(params[:function])

    respond_to do |format|
      if @function.save
        flash[:notice] = _('Function was successfully created.')
        format.html { redirect_to(@function) }
        format.xml  { render :xml => @function, :status => :created, :location => @function }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @function.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /functions/1
  # PUT /functions/1.xml
  def update
    @function = Function.find(params[:id])

    respond_to do |format|
      if @function.update_attributes(params[:function])
        flash[:notice] = _('Function was successfully updated.')
        format.html { redirect_to(@function) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @function.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /functions/1
  # DELETE /functions/1.xml
  def destroy
    @function = Function.find(params[:id])
    @function.destroy

    respond_to do |format|
      format.html { redirect_to(functions_url) }
      format.xml  { head :ok }
    end
  end
end
