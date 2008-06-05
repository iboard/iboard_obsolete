class AuthenticateController < ApplicationController
  
  ### SESSION HANDLING
  
  def login
  end
  
  def logout
     user.utok = nil
     user.save_without_validation!
     Log.log('Logout',user.id,'authentication',request.env['REMOTE_ADDR'])
     reset_session
     flash[:notice] = _('Goodbye')
     redirect_to root_path
  end

  def verify_login
    if params[:login]
      user = User.find_by_username(params[:login][:username])
      if user
         if Digest::SHA1.hexdigest(params[:login][:password])[0..39] == user.password
           if not user.locked
             session[:user] = user.id
             utok = Digest::SHA1.hexdigest(DateTime.now().to_s(:long))
             session[:utok]= utok
             user.utok = utok
             user.save_without_validation!
             Log.log('Successfull login', user.id, 'authentication', request.env['REMOTE_ADDR'])
             if session[:initial_uri] && session[:initial_uri] != root_path
               flash[:ok] = _('Welcome %{longname}! You are successfully logged in as %{shortname}') % 
                 { :shortname => user.username, :longname => user.longname }
               redirect_to session[:initial_uri]
             else
               redirect_to welcome_user_path(user)
             end
           else
             Log.log('Rejected login (user locked)' +  +"#{params[:login]}/#{params[:password]}", 
                nil, 'authentication', request.env['REMOTE_ADDR'])
             flash[:ok] = _('Sorry, your account is locked. Did you confirm your registration email?')
             redirect_to(welcome_user_path(user))
           end
           return
         else
           Log.log('Rejected login (wrong password) ' +"#{params[:login]}/#{params[:password]}", 
           nil, 'authentication', request.env['REMOTE_ADDR']) 
         end
      else
        Log.log('Rejected login (unknown user) ' +"#{params[:login]}/#{params[:password]}", 
            nil, 'authentication', request.env['REMOTE_ADDR']) 
      end
    end
    Log.log('Rejected login (no params)', nil, 'authentication', request.env['REMOTE_ADDR']) 
    flash[:error] = _('Bad username and/or passwort. Try again …')
    redirect_to :controller => "authenticate", :action => 'login'
    return
  end
  
end
