class NewsletterSubscriptionsController < ApplicationController

  before_filter :authenticate, :except => [:show, :edit, :destroy, :update ]

  def index
    @newsletter_subscriptions = NewsletterSubscription.find(:all,:order => 'email')
  end

  # GET /newsletters/new
  # GET /newsletters/new.xml
  def new
    @newsletter_subscription = NewsletterSubscription.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @newsletter_subscription }
    end
  end
  
  def subscribe
    @newsletters = Newsletter.find(:all,:order => 'name', :conditions => ['public_subscribable = ?', true])
    @subscriptions  = NewsletterSubscription.find_all_by_email(user.email)
  end
  
  def user_subscriptions
    @subscriptions  = NewsletterSubscription.find_all_by_email(user.email)
    id = params[:newsletter_id]
    nid = {}
    id.map { |i| 
      nid[:id]    = i[0]
      nid[:value] = i[1]
    }
    @newsletter = Newsletter.find(nid[:id])
    if user.email
      if nid[:value] == "true"
         @newsletter.subscribe(user.email)
      else
         @newsletter.unsubscribe(user.email)
      end
    else
      flash.now[:error] = _('Please set your email first!')
    end
    
    @subscriptions  = NewsletterSubscription.find_all_by_email(user.email)
    
    render :layout => false
  end

  # GET /newsletters/1
  # GET /newsletters/1.xml
  def show
    @newsletter_subscription = NewsletterSubscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @newsletter_subscription }
    end
  end

  # GET /newsletter/1/edit
  def edit
    @newsletter_subscription = NewsletterSubscription.find(params[:id])
  end

  # POST /newsletter
  # POST /newsletter.xml
  def create
    @newsletter_subscription = NewsletterSubscription.new(params[:newsletter_subscription])
    @newsletter_subscription.handling_code = random_stirng(10)
    Log.log("Subscription created #{@newsletter_subscription.email}/#{@newsletter_subscription.newsletter.name}",
      user.id,'newsletters',request.env['REMOTE_ADDR'])
    
    respond_to do |format|
      if @newsletter_subscription.save
        flash[:notice] = _('Newsletter Subscription was successfully created.')
        format.html { redirect_to(@newsletter_subscription) }
        format.xml  { render :xml => @newsletter_subscription, :status => :created, :location => @newsletter_subscription }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @newsletter_subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /newsletter/1
  # PUT /newsletter/1.xml
  def update
    @newsletter_subscription = NewsletterSubscription.find(params[:id])
    if user || params[:sc] == @newsletter_subscription.handling_code
      Log.log("Update #{@newsletter_subscription.email}/#{params.inspect}",user.id,'newsletters',request.env['REMOTE_ADDR'])
      respond_to do |format|
        if @newsletter_subscription.update_attributes(params[:newsletter_subscription])
          flash[:notice] = _('Newsletter Subscription was successfully updated.')
          format.html { redirect_to(newsletter_subscription_path(@newsletter_subscription,:sc => params[:sc])) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @newsletter_subscription.errors, :status => :unprocessable_entity }
        end
      end
    else
      access_denied(root_path)
    end
    
  end

  # DELETE /newsletter/1
  # DELETE /newsletter/1.xml
  def destroy
    @newsletter_subscription = NewsletterSubscription.find(params[:id])
    
    if user || params[:sc] == @newsletter_subscription.handling_code
      
      Log.log("Unsubscribe #{@newsletter_subscription.email}/#{@newsletter_subscription.newsletter.name}",user.id,'newsletters',request.env['REMOTE_ADDR'])
      @newsletter_subscription.destroy
      
      respond_to do |format|
        format.html {
          flash[:ok] = _('Subscription removed.')
          redirect_to( params[:sc] ? root_path : newsletters_path(:sc => params[:sc])) 
          }
        format.xml  { head :ok }
      end
    else
      access_denied(root_path)
    end
  end
  
end
