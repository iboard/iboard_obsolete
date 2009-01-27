class CollectorEntry < ActiveRecord::Base
  belongs_to :collector
  belongs_to :user
end
