######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class Newsletter < ActiveRecord::Base
  include IboardLibrary
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_presence_of   :from_address

  
  has_many    :newsletter_subscriptions, :dependent => :destroy
  has_many    :newsletter_templates,     :dependent => :destroy
  
  
  def email_subscripted?(email)
    NewsletterSubscription.find_by_email(email, :conditions => ['newsletter_id = ?', id])
  end
  
  def subscribe(email,name=nil)
    found = email.match(/(\S+@\S+)[\b]*(.*)/)
    unless found.nil?
      address = found[1].chomp.downcase.gsub(/^\[mailto:/,"").gsub(/\]$/,"")
      if name.nil?
        name = address.match(/(\S+)@(\S)/)[1]
      end
      subscription = NewsletterSubscription.create( 
        :email => address.downcase,
        :name => name,
        :newsletter_id => id, 
        :content_type => default_type,
        :handling_code => random_string(10))
      if subscription.save!
        return address
      end
    end
    return false
  end
  
  def unsubscribe(email)
    subscription = newsletter_subscriptions.find(:first,:conditions => ["email = ?",email] )
    if !subscription
      return false
    else
      subscription.destroy
      return true
    end
  end
  
  
end
