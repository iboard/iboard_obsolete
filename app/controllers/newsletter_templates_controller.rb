class NewsletterTemplatesController < ApplicationController
  
  before_filter :authenticate
  layout :get_application_layout
  
  def index
    @newsletter_templates = NewsletterTemplate.find(:all,:order => 'updated_at desc')
  end
  
  def new
    @newsletter_template = NewsletterTemplate.new
    @newsletter_template.newsletter = Newsletter.find(params[:newsletter_id])
  end
  
  def create
      @newsletter_template = NewsletterTemplate.new(params[:newsletter_template])

      respond_to do |format|
        if @newsletter_template.save
          flash[:notice] = 'Newsletter template was successfully created.'
          format.html { redirect_to(@newsletter_template) }
          format.xml  { render :xml => @newsletter, :status => :created, :location => @newsletter }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @newsletter_template.errors, :status => :unprocessable_entity }
        end
      end
  end
  
  def update
    @newsletter_template = NewsletterTemplate.find(params[:id])

    respond_to do |format|
      if @newsletter_template.update_attributes(params[:newsletter_template])
        flash[:notice] = 'Newsletter template was successfully updated.'
        format.html { redirect_to(@newsletter_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @newsletter_template.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @newsletter_template = NewsletterTemplate.find(params[:id])
  end
  
  def edit
    @newsletter_template = NewsletterTemplate.find(params[:id])
  end

  def send_now
    @newsletter_template = NewsletterTemplate.find(params[:id])
    session[:c_all]  = @newsletter_template.newsletter.newsletter_subscriptions.length
    session[:c_sent] = 0
    session[:c_error]=0
    session[:c_queued]="...."
    session[:c_finished] = false
  end
  
  def show_status
    t = session[:c_finished] ? _('Finished') : _('Running')
    cnt = NewsletterLog.find(:all,:conditions => ['newsletter_template_id = ?', params[:id]]).length
    render :text => "#{DateTime::now.to_s(:long)}: #{t}<br />Queued: #{session[:c_queued]} of #{session[:c_all]}, " +
                    "Sent: #{cnt}, Errors: #{session[:c_error]}"
  end
  
  def send_one_mail
    session[:c_queued] = params[:idx]
    @template = NewsletterTemplate.find(params[:id])
    @subscription = NewsletterSubscription.find(params[:newsletter_subscription_id])
    begin
      text = @template.body +
             @subscription.add_legals(
                  'http://' + request.env['SERVER_NAME'] + root_path + 'newsletter_subscriptions/' +
                   @subscription.id.to_s
             ) 
       body =  ( @subscription.content_type == 'text/html' ? interpret(text) : (text))
       NewsletterMailer.deliver_template( @template.newsletter.from_address,
            "#{@subscription.name} <#{@subscription.email}>",
             @template.subject,body,@subscription.content_type)
       rc = "<font color=green>"+_('sent')+"</font>"
       @subscription.log( @template ) 
       session[:c_sent] += 1       
    rescue ActionMailerError
      rc = "<font color=red>"+ _('Mailer error') +"</font>"
      #Log.log("Mailer-Error #{@subscription.email}/#{@template.subject}",user.id,'newsletters',request.env['REMOTE_ADDR'])
      session[:c_error] += 1
    rescue
      rc = "<font color=red>"+ _('unkown error') + "</font>"
      #Log.log("Unknown-Error #{@subscription.email}/#{@template.subject}",user.id,'newsletters',request.env['REMOTE_ADDR'])
      session[:c_error] += 1
    end 
    render :text => rc
  end
  
end
