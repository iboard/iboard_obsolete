class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.datetime :time_start
      t.datetime :time_end
      t.string :event_group
      t.string :title
      t.text :remarks
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
