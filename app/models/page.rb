######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class Page < ActiveRecord::Base
  belongs_to :div_tag
  belongs_to :function
  has_many   :page_columns
  has_many   :postings, :through => :page_columns
  validates_presence_of :name
  
  
  def self.load_with_columns(id)
    find(id,:include => [:page_columns], :order => 'page_columns.position' )
  end
  
  def self.find_for_menu(language,user=nil,servername='localhost')
     pages = find_all_by_language(language,
       :conditions => 
         ['show_in_menu = ? and restrict_to_function_id is ? and (only_for_domain is ? or only_for_domain = ? or only_for_domain = "")', 
           true,nil,
           nil, servername 
         ])
     if user
       a = Accessor.find_all_by_user_id(user)
       p2 = find(:all, :conditions => ['restrict_to_function_id in (?)', a])
       p2.each do |p|
         pages << p
       end
     end
     pages
  end
end
