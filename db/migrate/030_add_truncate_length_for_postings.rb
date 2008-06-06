class AddTruncateLengthForPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :truncate_length, :integer, :default => 512
  end

  def self.down
    remove_column :postings, :truncate_length
  end
end
