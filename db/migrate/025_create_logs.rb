class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string  :logtype, :default => 'system'
      t.integer :user_id, :default => nil
      t.string  :ip
      t.string  :entry
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
