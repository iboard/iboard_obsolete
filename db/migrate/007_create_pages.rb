class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.text :introduction
      t.boolean :show_title
      t.boolean :show_introduction
      t.integer :div_tag_id
      t.timestamps
    end
end

  def self.down
    drop_table :pages
  end
end
