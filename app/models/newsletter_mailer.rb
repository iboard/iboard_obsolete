######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class NewsletterMailer < ActionMailer::Base
  def template(from,address,subject,body,type)
    recipients              address
    from                    from
    subject                 subject
    body                    body
    if type != "text/plain" 
      content_type          type
    end
  end
end
