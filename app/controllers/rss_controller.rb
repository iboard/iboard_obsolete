class RssController < ApplicationController
  
  def index
    params[:language] ||= DEFAULT_LANGUAGE
    @columns = PageColumn.find(:all,
      :conditions => ['pages.restrict_to_function_id is null and pages.language = ?', (params[:language]||"en_US")],
      :include => [:page, :postings])
    @postings = []
    @columns.each { |c| 
      c.postings.each { |p|
        @postings << p 
      }
    }
    render :layout => "rssfeed"
  end
  
end
