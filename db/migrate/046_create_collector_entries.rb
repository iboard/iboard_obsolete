class CreateCollectorEntries < ActiveRecord::Migration
  def self.up
    create_table :collector_entries do |t|
      t.integer :collector_id
      t.integer :user_id
      t.string :fields
      t.text :values

      t.timestamps
    end
  end

  def self.down
    drop_table :collector_entries
  end
end
