class CreateShopItems < ActiveRecord::Migration
    
  def self.up
    create_table :shop_items do |t|
      t.string   :title
      t.text     :description
      t.float    :price
      t.integer  :shop_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_items
  end
end
