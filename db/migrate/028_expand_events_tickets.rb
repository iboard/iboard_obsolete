class ExpandEventsTickets < ActiveRecord::Migration
  def self.up
    add_column :events, :max_tickets, :integer, :default => 450
  end

  def self.down
    remove_column :events, :max_tickets
  end
end
