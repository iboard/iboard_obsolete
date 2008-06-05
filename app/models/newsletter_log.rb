class NewsletterLog < ActiveRecord::Base
  belongs_to  :newsletter_template
  belongs_to  :newsletter_subscription
end
