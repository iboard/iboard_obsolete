class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :nickname
      t.string :prename
      t.string :lastname
      t.string :secret
      t.date :date_birth
      t.integer :gender, :limit => 2, :default => 0
      t.integer :country, :limit => 4
      t.text :address
      t.string :zip, :limit => 10
      t.string :city
      t.string :email
      t.string :phone
      t.string :chat
      t.text :note
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :authors
  end
end
