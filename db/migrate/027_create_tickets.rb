class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :event_id
      t.string :name
      t.float :price
      t.string :reservation_code
      t.string :email
      t.integer :num_tickets
      t.text :note
      t.string :telephone

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
