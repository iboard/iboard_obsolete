class Ticket < ActiveRecord::Base
  validates_presence_of :event_id
  validates_presence_of :name
  validates_presence_of :price
  
  belongs_to  :event
end
