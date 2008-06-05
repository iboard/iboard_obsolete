module EventsHelper
  
  
  def month_links(layout='application')
    today = Date::today()
    start_at = Date::civil( today.year, today.month, 1)
    months = link_to( _('Events'), calendar_events_path(:location => layout) ) + "&nbsp;|&nbsp;"
    months += (0..2).map { |m|
      link_to( _((start_at+m.months).to_s(:event_month)), events_path(:month => (start_at+m.months), :layout => layout ))
    }.join('&nbsp;|&nbsp;')
    months += "&nbsp;|&nbsp;" + link_to( _('All...'), events_path(:layout => layout) )
  end
  
  def pages_links(layout='application')
    div_tag = DivTag.find_by_name(layout)
    if div_tag
      Page.find_all_by_div_tag_id(div_tag.id, :conditions => ["show_in_menu = ?", true]).map { |p|
        link_to( p.name, show_page_page_path(p, :layout => layout))
      }.join("&nbsp;|&nbsp;")
    end
  end
end
