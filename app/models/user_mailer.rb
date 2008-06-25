######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 


class UserMailer < ActionMailer::Base

  # For public user registration
  def registration_confirmation(user,host)
    recipients              user.email
    bcc                     REGISTRATION_COPY_TO_ADDRESS
    from                    REGISTRATION_FROM_ADDRESS
    subject                 _('Thank you for registering')
    body                    :user => user, :confirmation_url => REGISTRATION_HOST_PREFIX+
                            "/users/confirmation/"+user.id.to_s+"?code=#{user.confirmation_code}"
  end
  
  # Ticket Reservation
  def ticket_reservation(ticket,host)
    recipients              ticket.email
    bcc                     TICKET_COPY_TO_ADDRESS
    from                    TICKET_FROM_ADDRESS
    subject                 _('Ticket reservation for %{title} at %{date}') % { :title => ticket.event.title, :date => ticket.event.begins_at.to_s(:begins_at)}
    body                    :ticket => ticket
    content_type            "text/html"
  end
  
  # Send Password
  def send_password(user,new_password,host)
    recipients              user.email
    bcc                     REGISTRATION_COPY_TO_ADDRESS
    from                    REGISTRATION_FROM_ADDRESS
    subject                 _('New password for %s') % host
    body                    :user => user, :new_password => new_password
    content_type            "text/plain"
  end
  
  # Send Paypal notification
  def paypal_notification(receiver,notification,host)
    recipients              receiver
    from                    REGISTRATION_FROM_ADDRESS
    subject                 _('Paypal notification from %s') % host
    body                    :paypal_notification => notification
    content_type            "text/html"
  end
end
