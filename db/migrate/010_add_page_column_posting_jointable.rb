class AddPageColumnPostingJointable < ActiveRecord::Migration
  def self.up
      create_table :page_columns_postings, :id => false do |t|
        t.integer  :page_column_id
        t.integer :posting_id
      end
  end

  def self.down
    drop_table :page_columns_postings
  end
end
