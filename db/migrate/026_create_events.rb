class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string     :title
      t.datetime   :begins_at
      t.datetime   :ends_at
      t.boolean    :open_end
      t.text       :introduction
      t.text       :body
      t.integer    :picture_id
      t.text       :picture_text
      t.float      :price
      t.float      :price_prebooking
      t.float      :price_reduced
      t.string     :location
      t.string     :producer
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
