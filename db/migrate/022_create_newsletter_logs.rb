class CreateNewsletterLogs < ActiveRecord::Migration
  def self.up
    create_table :newsletter_logs do |t|
      t.integer :newsletter_template_id
      t.integer :newsletter_subscription_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_logs
  end
end
