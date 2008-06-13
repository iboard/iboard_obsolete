######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

class Ticket < ActiveRecord::Base
  validates_presence_of :event_id
  validates_presence_of :name
  validates_presence_of :price
  
  belongs_to  :event
end
