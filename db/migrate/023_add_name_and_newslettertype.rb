class AddNameAndNewslettertype < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscriptions, :name, :string
    add_column :newsletter_subscriptions, :content_type, :string, :default => "text/html"
  end

  def self.down
    remove_column :newsletter_subscriptions, :name
    remove_column :newsletter_subscriptions, :content_type
  end
end
