class DivTagsController < ApplicationController
  
  before_filter :authenticate
  layout :get_application_layout

  # GET /div_tags
  # GET /div_tags.xml
  def index
    @div_tags = DivTag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @div_tags }
    end
  end

  # GET /div_tags/1
  # GET /div_tags/1.xml
  def show
    @div_tag = DivTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @div_tag }
    end
  end

  # GET /div_tags/new
  # GET /div_tags/new.xml
  def new
    @div_tag = DivTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @div_tag }
    end
  end

  # GET /div_tags/1/edit
  def edit
    @div_tag = DivTag.find(params[:id])
  end

  # POST /div_tags
  # POST /div_tags.xml
  def create
    @div_tag = DivTag.new(params[:div_tag])

    respond_to do |format|
      if @div_tag.save
        flash[:notice] = _('DivTag was successfully created.')
        format.html { redirect_to(@div_tag) }
        format.xml  { render :xml => @div_tag, :status => :created, :location => @div_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @div_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /div_tags/1
  # PUT /div_tags/1.xml
  def update
    @div_tag = DivTag.find(params[:id])

    respond_to do |format|
      if @div_tag.update_attributes(params[:div_tag])
        flash[:notice] = _('DivTag was successfully updated.')
        format.html { redirect_to(@div_tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @div_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /div_tags/1
  # DELETE /div_tags/1.xml
  def destroy
    if params[:id].to_i == 1
      flash[:error] = _('You can\'t delete the default DIV-Tag')
      redirect_to(div_tags_url)
      return
    end
    @div_tag = DivTag.find(params[:id])
    @div_tag.destroy

    respond_to do |format|
      format.html { redirect_to(div_tags_url) }
      format.xml  { head :ok }
    end
  end
end
