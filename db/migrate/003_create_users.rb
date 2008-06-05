class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :longname
      t.string :password
      t.boolean :locked, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
