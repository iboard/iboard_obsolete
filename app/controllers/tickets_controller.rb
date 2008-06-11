class TicketsController < ApplicationController
  
  before_filter :authenticate, :except => [ :show, :new, :create ]
  layout :get_application_layout
  
  # GET /tickets
  # GET /tickets.xml
  def index
    if params[:event_id]
      @tickets = Ticket.find_all_by_event_id(params[:event_id])
    else
      @tickets = Ticket.find(:all)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    layout = params[:layout] || get_application_layout
    if (! granted_for?('tickets')) && (! params[:reservation_code] )
      render :text => _('Sorry, Access denied'), :layout => layout
      return true
    end
    @ticket = Ticket.find(params[:id])
    if params[:reservation_code] == @ticket.reservation_code
      respond_to do |format|
        format.html { render :layout => @ticket.event.location }
        format.xml  { render :xml => @ticket }
      end
    else
      render :text => _('Sorry, Access denied'), :layout => layout
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    @ticket = Ticket.new
    @event  = Event.find(params[:event])
    layout = @event.location
    
    if @event.sold_out?
      render :text => _('<div class="sold_out">Sorry, this event is sold out!</div>'),  :layout => layout
    else
      
      @ticket.price =  @event.price_prebooking
      @ticket.num_tickets = 1
      @send_code = random_string(5)
      mk_tmp_file(@send_code)
      
      respond_to do |format|
        format.html { render :layout => @event.location, :layout => layout }
        format.xml  { render :xml => @ticket }
      end
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = Ticket.new(params[:ticket])
    @event  = Event.find(params[:event_id])
    @ticket.event_id = @event.id
    conf_ok = check_sec_code(params[:sec_code],params[:send_code])
    if conf_ok
      respond_to do |format|
        if @ticket.save
          flash[:notice] = _('Ticket was successfully created.')
          @ticket.reservation_code=random_string(8)
          @ticket.save
          @ticket.email ||= TICKET_FROM_ADDRESS
          UserMailer.deliver_ticket_reservation(@ticket,request.env['SERVER_NAME'])
          flash[:notice] += _('Thank You! A copy was sent to %{email}.') % { :email => @ticket.email }

          format.html { redirect_to(ticket_path( @ticket, :reservation_code => @ticket.reservation_code, :method => :get )) }
          format.xml  { render :xml => @ticket, :status => :created, :location => @ticket.location }
        else
          @send_code = random_string(5)
          mk_tmp_file(@send_code)
          format.html { render :action => "new", :layout => @event.location }
          format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
        end
      end
    else
      @send_code = random_string(5)
      mk_tmp_file(@send_code)
      @ticket.errors.add(:sec_code, _('Secure code invalid'))
      render :action => "new", :layout => @event.location
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
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
