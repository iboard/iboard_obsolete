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
