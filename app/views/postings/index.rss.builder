xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{APPLICATION_TITLE} RSS FEED"
    xml.description "RSS Feed for #{APPLICATION_TITLE}"
    xml.link formatted_postings_url(:rss)
    
    for posting in @postings
      xml.item do
        xml.title posting.title
        xml.description posting.body
        xml.pubDate posting.updated_at.to_s(:rfc822)
        xml.link formatted_posting_url(posting, :html)
      end
    end
  end
end
