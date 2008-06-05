class UserToken < ActiveRecord::Migration
  def self.up
    add_column :users, :utok,:string, :default => 'not logged in yet'
  end

  def self.down
    remove_column :users, :utok
  end
end
