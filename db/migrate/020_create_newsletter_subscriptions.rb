class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscriptions do |t|
      t.integer :newsletter_id
      t.string :email
      t.string :subscripted_from
      t.string :handling_code
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_subscriptions
  end
end
