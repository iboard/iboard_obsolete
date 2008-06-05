class ExtendNewsletterModel < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :public_subscribable, :boolean, :default => true
    add_column :newsletters, :default_type, :string, :default => "text/html"
  end

  def self.down
    remove_column :newsletters, :public_subscribable
    remove_column :newsletters, :default_type
  end
end
