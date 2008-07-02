class Payment < ActiveRecord::Base
  belongs_to :shop_item
end
