xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{APPLICATION_TITLE} EVENTS RSS FEED"
    xml.description "EVENTS ANNOUNCED BY #{APPLICATION_TITLE}"
    xml.link formatted_events_url(:rss)
    
    for event in @events
      xml.item do
        xml.title event.title
        xml.description interpret(
           "#{event.begins_at.to_s(:begins_at)}\n"+
           "[[rsizedimage:#{event.picture_id}:300x300:#{event.title}]]" +
           "#{event.body}\n" +
           link_to( _('Tickets'), new_ticket_path(:event => event))
        )
        xml.pubDate event.updated_at.to_s(:rfc822)
        xml.link formatted_event_url(event, :rss)
      end
    end
  end
end
