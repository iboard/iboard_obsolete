######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 


#
# The Accessor-model controlls which user is granted to which function
# It's an HABTM-association
# 
class Accessor < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :function
  
 
  # Create default accessor(s) for newly registered users 
  def self.register_user(user,request)
    register_function(user,request,'registered users')
    register_function(user,request,'newsletter_subscriptions')
  end
  
  
  protected
  def self.register_function(user,request,function)
    fnc = Function.find_by_name(function)
    if !fnc
      fnc = Function.create( :name => function, :comment => "Autocreated when user #{user.username} confirms" )
    end
    new_accessor = create( :name => "#{user.username}:#{fnc.name}", 
            :user_id => user.id, :function_id => fnc.id, 
            :comment => "Registered at #{DateTime::now.to_s} from #{request.env['REMOTE_ADDR']}")
    new_accessor.save!
  end
  
end
