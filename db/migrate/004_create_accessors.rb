class CreateAccessors < ActiveRecord::Migration
  def self.up
    create_table :accessors do |t|
      t.string :name
      t.integer :user_id
      t.integer :function_id
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :accessors
  end
end
