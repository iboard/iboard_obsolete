class CreateDivTags < ActiveRecord::Migration
  def self.up
    create_table :div_tags do |t|
      t.string :name
      t.text :definition

      t.timestamps
    end
    
  end

  def self.down
    drop_table :div_tags
  end
end
