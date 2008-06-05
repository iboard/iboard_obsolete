class AddPostingPosition < ActiveRecord::Migration
  def self.up
    add_column :postings, :position, :integer, :default => 1
    add_column :page_columns, :default_order, :string, :default => 'updated_at desc'
  end

  def self.down
    remove_column :postings, :position
    remove_column :page_columns, :default_order
  end
end
