class AddPromotedEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :promoted, :boolean, :default => true
  end

  def self.down
    remove_column :events, :promoted
  end
end
