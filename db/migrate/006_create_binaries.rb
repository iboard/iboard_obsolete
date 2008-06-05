class CreateBinaries < ActiveRecord::Migration
  def self.up
    create_table :binaries do |t|
      t.string :title
      t.string :filename
      t.string :mime_type
      t.integer :size
      t.text   :description
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :binaries
  end
end
