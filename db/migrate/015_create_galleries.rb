class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name
      t.string :path
      t.text :description
      t.integer :thumb_width
      t.integer :thumb_height
      t.integer :web_width
      t.integer :web_height
      t.integer :function_id
      t.integer :user_id
      t.text :options
      t.integer :div_tag_id
      t.text :div_extras

      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
