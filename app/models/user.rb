class User < ActiveRecord::Base
  
  validates_presence_of   :username
  validates_uniqueness_of :username
  validates_presence_of   :longname
  validates_presence_of   :email
  
  has_many                :authors
  has_many                :postings, :through => :authors
  has_many                :accessors
  has_many                :functions, :through => :accessors
  has_many                :binaries
  
  
  # search for paginate
  def self.search(search_txt,page,per_page=10)
     paginate( :page => page, :per_page => 10,     
       :order      => 'username', 
       :conditions => ['username like ? or longname like ?', "%#{search_txt}%","%#{search_txt}%"] )
   end
  
  # Virtual Attributes
  # password_field - crypt if different from stored string
  # (means it's a plaintext password just entered by the user)
  # and store in field 'password'
  def password_field=(plaintext)
    if plaintext != self.password
      self.password = Digest::SHA1.hexdigest(plaintext)[0..39] 
    end
  end
  
  # wrapper for crypted password field
  def password_field
    self.password
  end
  
  
  # Set array of assigned functions and create Accessors
  def function_ids=(function_ids)
    if self.id
      # delete old accessors for user
      accessors = Accessor.find_all_by_user_id(self.id)
      if accessors
        accessors.each(&:destroy)
      end
      
      # create new accessors for user
      function_ids.each do |fnc_id|
        Accessor.create( :name => "#{self.username}:#{Function.find(fnc_id).name}", 
                         :user_id => self.id, :function_id => fnc_id,
                         :comment => 'autogenerated by editing user' )
      end
    end
  end

  def self.opts_for_select
    find(:all, :order => 'username').map { |u| [ "#{u.longname} (#{u.username})", u.id ] }      
  end  
end
