class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string   :txn_id
      t.text     :notification
      t.integer  :shop_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
