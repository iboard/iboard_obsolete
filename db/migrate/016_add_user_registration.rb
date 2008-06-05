class AddUserRegistration < ActiveRecord::Migration
  def self.up
    add_column :users, :email,:string, :default => nil
    add_column :users, :registered_at, :datetime, :default => nil
    add_column :users, :confirmed_at,  :datetime, :default => nil
    add_column :users, :confirmation_code, :string
    add_column :users, :confirmed_from_ip, :string
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :registered_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_code
    remove_column :users, :confirmed_from_ip
  end
end
