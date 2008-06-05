class Posting < ActiveRecord::Base
  belongs_to :author
  belongs_to :function, :foreign_key => :restrict_to_function_id
  has_and_belongs_to_many :page_columns
  validates_presence_of :title
  validates_presence_of :body
  
  
  def self.search(search_txt,date_exp,page,per_page=10)
    paginate( :page => page, :per_page => per_page,     
      :order      => 'updated_at desc', 
      :conditions => ['date_expires > ? and (title like ? or body like ?)', date_exp.to_s(:db),
        "%#{search_txt}%","%#{search_txt}%"])
  end
  
  # Check if posting is allowed to be edited
  def editable_by_user?(user)
    (user and user.id == 1) or                        # by root
    (allow_editing == 99) or                          # it's public editable
    (allow_editing == 0 and author and author.user == user) or   # it's the author
    (allow_editing == 1 and user ) or                 # it's editable by any registered user
    (allow_editing == 2 and user.functions.include?(restricted_to_function_id)) # user is member of function
  end
end
