class CreatePageColumns < ActiveRecord::Migration
  def self.up
    create_table :page_columns do |t|
      t.string  :title
      t.integer :page_id
      t.integer :position
      t.integer :div_tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :page_columns
  end
end
