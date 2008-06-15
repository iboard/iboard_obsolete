######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class PageColumn < ActiveRecord::Base
  belongs_to  :page
  belongs_to  :div_tag
  has_and_belongs_to_many :postings
  
  
  def load_postings(page,per_page)
    @postings ||= postings.paginate( 
        :page => page, :per_page => per_page, :order => self.default_order,
        :order => self.default_order
     )
  end
  
end
