class NewslettersController < ApplicationController
  before_filter :authenticate
  layout :get_application_layout
  
  def index
    @newsletters = Newsletter.find(:all,:order => 'name')
  end
  
  # GET /newsletters/new
  # GET /newsletters/new.xml
  def new
    @newsletter = Newsletter.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @newsletter }
    end
  end
  
  # GET /newsletters/1
  # GET /newsletters/1.xml
  def show
    @newsletter = Newsletter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @newsletter }
    end
  end

  # GET /newsletter/1/edit
  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  # POST /newsletter
  # POST /newsletter.xml
  def create
    @newsletter = Newsletter.new(params[:newsletter])

    respond_to do |format|
      if @newsletter.save
        flash[:notice] = 'Newsletter was successfully created.'
        format.html { redirect_to(@newsletter) }
        format.xml  { render :xml => @newsletter, :status => :created, :location => @newsletter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /newsletter/1
  # PUT /newsletter/1.xml
  def update
    @newsletter = Newsletter.find(params[:id])

    respond_to do |format|
      if @newsletter.update_attributes(params[:newsletter])
        flash[:notice] = 'Newsletter was successfully updated.'
        format.html { redirect_to(@newsletter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @newsletter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /newsletter/1
  # DELETE /newsletter/1.xml
  def destroy
    @newsletter = Newsletter.find(params[:id])
    Log.log('Delete newsletter ' + " #{@newsletter.name}",user.id,'newsletters',request.env['REMOTE_ADDR'])
    @newsletter.destroy

    respond_to do |format|
      format.html { redirect_to(newsletters_url) }
      format.xml  { head :ok }
    end
  end
  
  def list_subscriptions
    @newsletter = Newsletter.find(params[:id])
  end
  
  def send_newsletter
    @newsletter = Newsletter.find(params[:id])
    redirect_to( new_newsletter_template_path(:newsletter_id => @newsletter))
  end
  
  
  def import_addresses
    @newsletter = Newsletter.find(params[:id])
  end
  
  def create_subscriptions
    @newsletter = Newsletter.find(params[:id])
    @new_subscriptions = []
    flash[:notice] = ""
    params[:addresses].split(/[\n|,|;|\b|\r]/).each do |address|
      unless address.chomp.empty?
        begin
          added = @newsletter.subscribe(address)
          Log.log("Add #{address} to #{@newsletter.name}",user.id,'newsletters',request.env['REMOTE_ADDR'])
        rescue
          added = false
          Log.log("Add #{address} to #{@newsletter.name} FAILED",user.id,'newsletters',request.env['REMOTE_ADDR'])
        end
        if added
          @new_subscriptions << _('<font color=green>%s</font>') % added
        else
          @new_subscriptions << _('<font color=red>%s</font>') % address
        end
      end
    end
  end
  
  def remove_addresses
    @newsletter = Newsletter.find(params[:id])
  end
  
  def remove_subscriptions
    @newsletter = Newsletter.find(params[:id])
    @removed_subscriptions = []
    flash[:notice] = ""
    params[:addresses].split(/[\n|,|;|\b|\r]/).each do |address|
      email = address.gsub(/(\S+@\S+)(.*)/,'\1').chomp.downcase
      unless email.empty?
        if @newsletter.unsubscribe(email)
          Log.log("Remove #{email} from #{@newsletter.name}",user.id,'newsletters',request.env['REMOTE_ADDR'])          
          @removed_subscriptions << _('<font color=green>%s</font>') % email
        else
          Log.log("Remove #{email} from #{@newsletter.name} FAILED",user.id,'newsletters',request.env['REMOTE_ADDR'])
          @removed_subscriptions << _('<font color=red>%s</font>') % email
        end
      end
    end
  end
    
end

