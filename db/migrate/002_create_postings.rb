class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string :title
      t.text :body
      t.integer :author_id
      t.date :date_expires
      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
