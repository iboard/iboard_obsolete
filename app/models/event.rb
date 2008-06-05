class Event < ActiveRecord::Base
  has_one  :binary
  has_many :tickets
  validates_presence_of :title
  validates_presence_of :begins_at
  validates_presence_of :introduction
  
  
  def split_body
    body.split("||")
  end
  
  def sold_out?
    n = tickets.sum(:num_tickets) || 0
    n >= max_tickets
  end
  
end
