######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 


#
# Author is not fully implemented yet but is used for postings.
# It's designated as a profile-model for activ users and posters
#
class Author < ActiveRecord::Base
  
  validates_presence_of   :nickname
  validates_uniqueness_of :nickname

  validates_presence_of :prename
  validates_presence_of :lastname
  
  belongs_to            :user
  has_many              :postings
  
  def date_birth_string
    date_birth.to_s(:db) unless date_birth.nil?
  end
  
  def date_birth_string=(str)
    self.date_birth = Date.parse(str)
  rescue ArgumentError
    @date_birth_invalid = true
  end
  
  def validate
    errors.add(:date_birth, _("is invalid")) if @date_birth_invalid
  end
  
  def display_name
    if (user)
      "#{prename} #{lastname} (#{user.username})"
    else
      "#{prename} #{lastname}"    
    end
  end
end
