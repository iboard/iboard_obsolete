class ExtendShoppingModdel < ActiveRecord::Migration
  def self.up
    add_column :shops, :seller, :text
    add_column :shops, :terms_and_conditions, :text
    
    add_column :shop_items, :stock,         :integer, :default => 0
    add_column :shop_items, :delivery_note, :string,  :default => ''
    add_column :shop_items, :delivery_time, :string,  :default => ''
    add_column :shop_items, :delivery_type, :integer,  :default => 1     #0=download, #1=shipping, ...
    add_column :shop_items, :tax,           :float,   :default => 0.0
  end

  def self.down
    remove_column :shops, :seller
    remove_column :shops, :terms_and_conditions
    
    remove_column :shop_items, :stock         
    remove_column :shop_items, :delivery_note
    remove_column :shop_items, :delivery_time 
    remove_column :shop_items, :delivery_type 
    remove_column :shop_items, :tax  
  end
end
