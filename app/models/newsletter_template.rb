class NewsletterTemplate < ActiveRecord::Base
  validates_presence_of :subject, :body
  
  belongs_to :newsletter
  has_many   :newsletter_logs
end
