######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class Log < ActiveRecord::Base
  
  def self.search(search_txt,page,per_page=10)
    paginate( :page => page, :per_page => per_page,     
      :order      => 'updated_at desc', 
      :conditions => ['created_at like ? or ip like ? or logtype like ? or entry like ?',
         "%#{search_txt}%","%#{search_txt}%","%#{search_txt}%","%#{search_txt}%"])
  end
  
  def self.log(entry,user_id,logtype='system',ip='unknown')
    Log.create( :user_id => user_id,
                :ip => ip,
                :logtype => logtype,
                :entry => entry
              )
  end
end
