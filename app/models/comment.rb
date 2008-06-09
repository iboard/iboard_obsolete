class Comment < ActiveRecord::Base

  belongs_to  :posting
  belongs_to  :event
  belongs_to  :user
  
  def rating_stars
    (1..5).each do |star|
      if star <= rating
        "<img src=/iboard/star_filled.gif  tile='#{rating} stars' alt='#{raiting} stars'>"
      else
        "<img src=/iboard/star.gif tile='#{rating} stars' alt='#{raiting} stars'>"
      end
    end
  end
  
  def self.avg_stars(comments)
    if comments.nil? || comments.length < 1 
      return 0.to_f
    end
    ratings = []
    comments.each do |c|
      ratings << c.rating if c.rating
    end
    if rating.length > 0
      ratings.sum/ratings.length
    else
      0
    end
  end
end
