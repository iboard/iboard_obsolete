class CreateCollectors < ActiveRecord::Migration
  def self.up
    create_table :collectors do |t|
      t.string :name
      t.string :groups
      t.text :description
      t.string :fields
      t.text :values

      t.timestamps
    end
  end

  def self.down
    drop_table :collectors
  end
end
