class GalleriesController < ApplicationController
  
  before_filter :authenticate, :except => ['show', 'thumbnail', 'show_picture', 'webgallery']
  
  # GET /galleries
  # GET /galleries.xml
  def index
    @galleries = Gallery.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.xml
  def new
    @gallery = Gallery.new
    @gallery.function_id = nil
    @gallery.user_id = nil
    @gallery.options = nil
    @gallery.div_tag_id = nil
    @gallery.div_extras = nil
    @gallery.thumb_width = 64
    @gallery.thumb_height = 64
    @gallery.web_width = 640
    @gallery.web_height = 480
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to(@gallery) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'
        format.html { redirect_to(@gallery) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to(galleries_url) }
      format.xml  { head :ok }
    end
  end
  
  def thumbnail
    if ! params[:filename]
      return 
    end
    pw = params[:width]  || "64"
    ph = params[:height] || "64"
    picsize = "#{pw}x#{ph}"
    
    cache_file_name = Digest::SHA1.hexdigest(params[:filename]+picsize)
    
    if File::exists?( GALLERY_CACHE_PREFIX + "/" + cache_file_name )
      f = File.new(GALLERY_CACHE_PREFIX + "/" + cache_file_name, "r" )
      data = f.sysread(File::size(GALLERY_CACHE_PREFIX + "/" + cache_file_name))
      f.close
    else
      data = Binary.new().thumbnail(picsize, GALLERY_PATH_PREFIX + "/" + params[:filename])
      f = File.new(GALLERY_CACHE_PREFIX + "/" + cache_file_name, "w+" )
      f << data
      f.close
    end
    send_data(data, :type => "image/jpg", :disposition => 'inline', :filename => params[:filename])
    return
  end
  
  def show_picture
    render :layout => false
  end
  
  def webgallery
    @gallery = Gallery.find(params[:id])
    layout = params[:layout] || 'application'
    layout = 'application' if layout.empty? 
    render :layout => layout
  end
  
end
