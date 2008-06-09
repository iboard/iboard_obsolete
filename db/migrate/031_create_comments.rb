class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :posting_id
      t.integer :event_id
      t.integer :user_id
      t.float :rating
      t.text :body
      t.string :email
      t.string :ip_remote

      t.timestamps
    end
    
    
    add_column  :events,   :allow_comments, :boolen, :default => false
    add_column  :postings, :allow_comments, :string, :default => false
  end

  def self.down
    drop_table :comments
    remove_column  :events,   :allow_comments
    remove_column  :postings, :allow_comments
  end
end
