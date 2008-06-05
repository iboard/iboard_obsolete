class AddLanguageColumnToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :language, :string, :default => 'en_US', :size => 10
  end

  def self.down
    remove_column :pages, :language
  end
end
