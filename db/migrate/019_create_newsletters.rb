class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string   :name
      t.text     :description
      t.integer  :user_id
      t.string   :from_address
      t.text     :footer
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
