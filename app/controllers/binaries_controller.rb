class BinariesController < ApplicationController
  
  before_filter :authenticate, :except => [:thumbnail,:embed,:preview,:original,:download,:send_image ] 
  layout :get_application_layout
  
  
  # GET /binaries
  # GET /binaries.xml
  def index
    @binaries = Binary.search(params[:search_binary], params[:page], 4)

    if params[:observer] == "1"
       params[:observer] = "0"
       render :layout => false
       return
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @binaries }
    end
  end

  # GET /binaries/1
  # GET /binaries/1.xml
  def show
    @binary = Binary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @binary }
    end
  end

  # GET /binaries/new
  # GET /binaries/new.xml
  def new
    @binary = Binary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @binary }
    end
  end

  # GET /binaries/1/edit
  def edit
    @binary = Binary.find(params[:id])
  end

  # POST /binaries
  # POST /binaries.xml
  def create
    @binary = Binary.new(params[:binary])

    respond_to do |format|
      if @binary.save
        flash[:notice] = _('Binary was successfully created.')
        if ! params[:mime_type] == 'new'
          format.html { redirect_to(@binary) }
        else
          format.html { redirect_to( edit_binary_path @binary) }
        end
        format.xml  { render :xml => @binary, :status => :created, :location => @binary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @binary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /binaries/1
  # PUT /binaries/1.xml
  def update
    @binary = Binary.find(params[:id])
    begin
      if params[:binary][:uploaded_file] 
        params[:binary][:mime_type] = params[:binary][:uploaded_file].content_type || "application/binary"
      end
    rescue
    end
    
    respond_to do |format|
      if @binary.update_attributes(params[:binary])
        flash[:notice] = _('Binary was successfully updated.')
        format.html { redirect_to(@binary) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @binary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /binaries/1
  # DELETE /binaries/1.xml
  def destroy
    @binary = Binary.find(params[:id])
    @binary.destroy

    respond_to do |format|
      format.html { redirect_to(binaries_url) }
      format.xml  { head :ok }
    end
  end
  
  def thumbnail
    if ! params[:id]
      return 
    end
    picsize = params[:size] || "64x64"
    @binary = Binary.find(params[:id])
    
    cache_file_name = Digest::SHA1.hexdigest(@binary.filename+picsize)
    if File::exists?( GALLERY_CACHE_PREFIX + "/" + cache_file_name )
    f = File.new(GALLERY_CACHE_PREFIX + "/" + cache_file_name, "r" )
      data = f.sysread(File::size(GALLERY_CACHE_PREFIX + "/" + cache_file_name))
      f.close
    else
      data = @binary.thumbnail picsize
      begin
        f = File.open(GALLERY_CACHE_PREFIX + "/" + cache_file_name, "w+" )
        f << data
        f.close
      rescue
        # file could not be saved in cache
      end
    end
    if ['image/jpg','image/gif','image/png', 'image/jpeg'].include?(@binary.mime_type) && 
       File::exists?(@binary.get_path + "/" + @binary.filename)
        send_data(data, :type => @binary.mime_type, :disposition => 'inline')
    else
        send_data(data, :type => "image/gif", :disposition => 'inline')
    end
    return
  end
  
  def embed
    @binary = Binary.find(params[:id])
    render :text => @binary.embed(original_binary_path(@binary),params[:width].to_i,params[:height].to_i), :layout=> false
  end
  
  def preview
    @binary = Binary.find(params[:id])
    render :layout => false 
  end
  
  def original
    if ! params[:id]
      return 
    end
    @binary = Binary.find(params[:id])
    if File::exists?(@binary.get_path + "/" + @binary.filename)
      send_file(@binary.get_path + "/" + @binary.filename, :filename => @binary.filename, 
        :type => @binary.mime_type, :disposition => 'inline')
    else
      send_file("#{RAILS_ROOT}/public/images/filenotfound.gif", :filename => @binary.filename, 
        :type => "image/gif", :disposition => 'inline')
    end
    return
  end
  
  def send_image
    filename = Base64::decode64(params[:file])
    send_file(filename, :filename => 'confirm.jpg', :type => "image/jpg", :disposition => 'inline')
  end
 
  def download
    if ! params[:id]
      flash[:error] = _('Binary not found')
      return
    end
    @binary = Binary.find(params[:id])
    if File::exists?(@binary.get_path + "/" + @binary.filename)
      send_file( @binary.get_path + "/" + @binary.filename, :filename => @binary.filename, 
        :type => "application/binary", :disposition => 'attachment', :stream => true)
      return
    else
      flash[:error] = _('Binary not found')
      redirect_to @binary
    end
    return
  end
end
