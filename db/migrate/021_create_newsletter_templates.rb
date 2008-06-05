class CreateNewsletterTemplates < ActiveRecord::Migration
  def self.up
    create_table :newsletter_templates do |t|
      t.string :subject
      t.integer :newsletter_id
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_templates
  end
end
