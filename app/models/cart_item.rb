class CartItem < ActiveRecord::Base
  belongs_to :chart
  has_one    :shop_item
end
