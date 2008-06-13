######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

#
# EVENT: First implemented for www.thesoundtheatre.com
# 
class Event < ActiveRecord::Base
  
  has_one  :binary
  has_many :tickets
  has_many :comments
  
  validates_presence_of :title
  validates_presence_of :begins_at
  validates_presence_of :introduction
  
  
  #
  # Split body-text to several columns when display it with event.show
  #
  def split_body
    body.split("||")
  end
  
  #
  # true if all tickets are reserved
  #
  def sold_out?
    n = tickets.sum(:num_tickets) || 0
    n >= max_tickets
  end
  
  #
  # Calculate average star-rating of all comments of this event
  #
  def avg_stars
    c = Comment.find_all_by_event_id(self)
    if c && c.length > 0
      s = 0
      c.each { |comment| s+= comment.rating }
      s/c.length
    else
      0
    end
  end

end
