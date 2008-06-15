class MaxPostingsPerColumn < ActiveRecord::Migration
  def self.up
    add_column :page_columns, :max_postings, :integer, :default => 10
  end

  def self.down
    remove_column :page_columns, :max_postings
  end
end
