class PagePosition < ActiveRecord::Migration
  def self.up
    add_column :pages, :position, :integer, :default => 0
  end

  def self.down
    remove_column :pages, :position
  end
end
