class Cart < ActiveRecord::Base
  has_many   :shop_items
  belongs_to :user
end
