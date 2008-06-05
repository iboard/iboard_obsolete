class Accessor < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :function
  
  
  def self.register_user(user,request)
    
    # Save registered_user
    fnc = Function.find_by_name('registered users')
    if !fnc
      fnc = Function.create( :name => 'registered users', :comment => "Autocreated when user #{user.username} confirms" )
    end
    new_accessor = create( :name => "#{user.username}:#{fnc.name}", 
            :user_id => user.id, :function_id => fnc.id, 
            :comment => "Registered at #{DateTime::now.to_s} from #{request.env['REMOTE_ADDR']}")
    new_accessor.save!
    
    # Allow newsletter_subscription
    fnc = Function.find_by_name('newsletter_subscriptions')
    if !fnc
      fnc = Function.create( :name => 'newsletter_subscriptions', :comment => "Autocreated when user #{user.username} confirms" )
    end
    new_accessor = create( :name => "#{user.username}:#{fnc.name}", 
            :user_id => user.id, :function_id => fnc.id, 
            :comment => "Registered at #{DateTime::now.to_s} from #{request.env['REMOTE_ADDR']}")
    new_accessor.save!
  end
  
end
