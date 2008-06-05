class UsersController < ApplicationController

  before_filter  :authenticate, :except => [ :register, :create_registration, :confirmation ]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.search(params[:search_user],params[:page],10)

    if params[:observer] == "1"
      params[:observer] = "0"
      render :layout => false
      return
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = _('User was successfully created.')
        format.html { redirect_to( edit_user_path @user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /users
  # POST /users.xml
  def create_registration
    @user = User.new(params[:user])
    @user.locked = true
    @user.confirmation_code = random_string(12)
    conf_ok = check_sec_code(params[:sec_code],params[:send_code])
    if ( params[:confirm] == params[:user][:password_field] ) && conf_ok
      if @user.save
        UserMailer.deliver_registration_confirmation(@user,request.env['SERVER_NAME'])
        flash[:notice] = _('Thank You! Your confirmation-code was sent to %{email}.<br />Please check your mail before you login.') % { :email => @user.email }
        redirect_to( root_path )
        return
      end
    end
    flash[:error] = ""
    if (params[:confirm] !=  params[:user][:password_field] )
      flash[:error] = _('Password mismatch. Please try again.')
    end
    if ! conf_ok
      flash[:error] += "<br/>"+_('Secure code invalid')
    end
    @send_code = random_string(5)
    mk_tmp_file(@send_code)
    render :action => "register"
  end
  
  def confirmation
    @user = User.find(params[:id])
    if params[:code] == @user.confirmation_code
      @user.locked = false
      @user.confirmed_at = DateTime::now().to_s(:db)
      @user.confirmed_from_ip = request.env['REMOTE_ADDR']
      flash[:ok] = _('Welcome! Your registration was completed successfully. Please login now.')
      flash[:notice] = _('Your registration was logged at %{t} from %{ip}') % { :t => @user.confirmed_at, :ip => @user.confirmed_from_ip}
      @user.save!
      Accessor.register_user(@user,request)
      redirect_to login_path
    else
      flash[:error] = _('Sorry, this code is invalid. Please try again: ') 
      redirect_to register_users_path
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    params[:user][:function_ids] ||= []
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = _('User was successfully updated.')
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if params[:id] == "1"
      flash[:error] = _('You can\'t delete the root-user!')
      redirect_to users_path
      return
    end
    @user = User.find(params[:id])
    Accessor.find_all_by_user_id(@user.id).each do |acc|
      acc.destroy
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def welcome
    @user = User.find(params[:id])
  end
  
  def registrations
    @registrations = User.find(:all)
  end
  
  def register
    @user = User.new
    @send_code = random_string(5)
    mk_tmp_file(@send_code)
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
      #raise "*#{user_input}* ? *#{code.chop}*"
      f.close
      File::unlink(fn)
      File::unlink("/tmp/#{sec_code}.image.iboard.cc.jpg")
    end
    rc #.to_s + "*#{user_input.chomp}* != *#{code.chomp}*"
  end
end
