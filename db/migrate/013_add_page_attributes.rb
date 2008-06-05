class AddPageAttributes < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_in_menu,            :boolean, :default => true
    add_column :pages, :restrict_to_function_id, :integer, :default => nil
  end

  def self.down
    remove_column :pages, :show_in_menu
    remove_column :pages, :restrict_to_function_id
  end
end
