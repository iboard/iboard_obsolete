class CommentsController < ApplicationController

  layout :get_application_layout
  
  before_filter :authenticate, :except => [:show,:new,:create,:set_rating,:index]

  # GET /comments
  # GET /comments.xml
  def index
    layout = get_application_layout
    case params[:item]
    when "Posting"
      @posting = Posting.find(params[:item_id])
      @comments = 
        Comment.find(:all, :include => [:posting, :event, :user], :order => 'comments.created_at desc',
                     :conditions => [ 'posting_id  = ?',
                                      params[:item_id]
                                    ]
                    )
    when "Event"
      @event = Event.find(params[:item_id])
      @comments = 
        Comment.find(:all, :include => [:posting, :event, :user],  :order => 'comments.created_at desc',
                     :conditions => [ 'event_id  = ?',
                                      params[:item_id]
                                    ]
                    )
    else
      @comments = Comment.find(:all, :include => [:posting, :event, :user])
    end

    respond_to do |format|
      format.html { render :layout => layout}
      format.xml  { render :xml => @comments }
    end
    
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    layout = get_application_layout
    
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      format.html  { render :layout => layout}
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    layout = get_application_layout
    @comment = Comment.new
    @comment.ip_remote = request.env['REMOTE_ADDR']
    @comment.user = user
    
    @send_code = random_string(5)
    mk_tmp_file(@send_code)
    
    if params[:posting]
      @comment.posting = Posting.find(params[:posting].to_i)
    end
    if params[:event]
      @comment.event = Event.find(params[:event].to_i)
    end
    respond_to do |format|
      format.html  { render :layout => layout}
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    item = @comment.posting || @comment.event

    conf_ok = check_sec_code(params[:sec_code],params[:send_code])

    if conf_ok
       respond_to do |format|
         if @comment.save
           flash[:notice] = 'Comment was successfully created.'
           format.html { redirect_to(item) }
           format.xml  { render :xml => @comment, :status => :created, :location => @comment }
         else
           @send_code = random_string(5)
           mk_tmp_file(@send_code)
           format.html { render :action => "new" }
           format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
         end
       end
     else
         @send_code = random_string(5)
         mk_tmp_file(@send_code)
         @comment.errors.add(:sec_code, _('Secure code invalid'))
         render :action => "new"
     end
  end
  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
  
  def set_rating
    @comment = Comment.find(params[:id], :include => ['posting','event'])
    @comment.rating = params[:rating].to_f
    @comment.save
    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
    end
  end
  
  private
  def mk_tmp_file(send_code)
    code = random_string(5)
    f = File::new("/tmp/#{send_code}.sendcode.iboard.cc","w")
    f.puts(code)
    f.close
  end
  
  
  def check_sec_code(user_input,sec_code)
    rc = false
    return rc if user_input.empty? or sec_code.empty?
    fn =  "/tmp/#{sec_code}.sendcode.iboard.cc"
    if File::exists?(fn) 
      f = File::open(fn,"r")
      code = f.gets
      rc = (user_input.chomp.eql?(code.chomp))
      f.close
      File::unlink(fn)
      File::unlink("/tmp/#{sec_code}.image.iboard.cc.jpg")
    end
    rc
  end
  
end
