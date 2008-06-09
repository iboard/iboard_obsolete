class Event < ActiveRecord::Base
  
  has_one  :binary
  has_many :tickets
  has_many :comments
  
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
