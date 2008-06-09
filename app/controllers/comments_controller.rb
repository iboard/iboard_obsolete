class CommentsController < ApplicationController

  # GET /comments
  # GET /comments.xml
  def index
    case params[:item]
    when "Posting"
      @posting = Posting.find(params[:item_id])
      @comments = 
        Comment.find(:all, :include => [:posting, :event], :order => 'comments.created_at desc',
                     :conditions => [ 'posting_id  = ?',
                                      params[:item_id]
                                    ]
                    )
    when "Event"
      @posting = Event.find(params[:item_id])
      @comments = 
        Comment.find(:all, :include => [:posting, :event],  :order => 'comments.created_at desc',
                     :conditions => [ 'event_id  = ?',
                                      params[:item_id]
                                    ]
                    )
    else
      @comments = Comment.find(:all, :include => [:posting, :event])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
    
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    @comment.ip_remote = request.env['REMOTE_ADDR']

    if params[:posting]
      @comment.posting = Posting.find(params[:posting].to_i)
    end
    if params[:event]
      @comment.event = Event.find(params[:event].to_i)
    end
    respond_to do |format|
      format.html # new.html.erb
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


    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(item) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
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
  
end
