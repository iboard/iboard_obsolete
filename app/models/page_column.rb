class PageColumn < ActiveRecord::Base
  belongs_to  :page
  belongs_to  :div_tag
  has_and_belongs_to_many :postings
  
  
  def load_postings
    @postings ||= postings.find(:all,:order => self.default_order)
  end
  
end
