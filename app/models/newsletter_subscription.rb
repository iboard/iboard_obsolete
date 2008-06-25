######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class NewsletterSubscription < ActiveRecord::Base
  validates_presence_of   :email
  validates_uniqueness_of :email, :scope => [:newsletter_id]
  belongs_to :newsletter
  has_many   :newsletter_logs
  
  def log( template )
    NewsletterLog.create(
      :newsletter_template_id => template.id,
      :newsletter_subscription_id => id,
      :status => 'Sent'
    )
  end
  
  def find_log(template )
    NewsletterLog.find(:first,:conditions => ['newsletter_template_id = ? and newsletter_subscription_id = ?',
      template.id, id])
  end

  # TODO: Make this string configurable or gettexted at least
  def add_legals(edit_url)
    u = edit_url + "?sc=#{handling_code}"
    txt = "\n--------------------\n\n" +
    newsletter.footer +
    "\n\nUNSUBSCRIBE/EDIT SUBSCRIPTION:\n\nABMELDEN/EINSTELLUNGEN:\n\n   #{u}\n\n---end--\n"
    txt
  end  
  
 
end
