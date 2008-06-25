######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

#
# Comments can be posted to 'Postings' and 'Events'
#
class Comment < ActiveRecord::Base

  belongs_to  :posting
  belongs_to  :event
  belongs_to  :user
  
  validates_presence_of :body
  validates_inclusion_of :rating, :in => 1..5, :message => _('Please rate between 1 and 5 stars')
  
  #
  # Create HTML-Code to display the stars
  #
  def rating_stars
    (1..5).each do |star|
      if star <= rating
        "<img src=/iboard/star_filled.gif  tile='#{rating} stars' alt='#{raiting} stars'>"
      else
        "<img src=/iboard/star.gif tile='#{rating} stars' alt='#{raiting} stars'>"
      end
    end
  end
  
  #
  # Calculate the average of all ratings of given comments
  #
  def self.avg_stars(comments)

    # prevent from division by zero
    if comments.nil? || comments.length < 1 
      return 0.to_f
    end

    # Sum and calculate ratings
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
