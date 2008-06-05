class UserMailer < ActionMailer::Base
  def registration_confirmation(user,host)
    recipients              user.email
    bcc                     REGISTRATION_COPY_TO_ADDRESS
    from                    REGISTRATION_FROM_ADDRESS
    subject                 _('Thank you for registering')
    body                    :user => user, :confirmation_url => REGISTRATION_HOST_PREFIX+
                            "/users/confirmation/"+user.id.to_s+"?code=#{user.confirmation_code}"
  end
  
  def ticket_reservation(ticket,host)
    recipients              ticket.email
    bcc                     TICKET_COPY_TO_ADDRESS
    from                    TICKET_FROM_ADDRESS
    subject                 _('Ticket reservation for %{title} at %{date}') % { :title => ticket.event.title, :date => ticket.event.begins_at.to_s(:begins_at)}
    body                    :ticket => ticket
    content_type            "text/html"
  end
end
