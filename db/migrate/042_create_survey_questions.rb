class CreateSurveyQuestions < ActiveRecord::Migration
  def self.up
    create_table :survey_questions do |t|
      t.text :question
      t.integer :survey_id
      t.integer :qtype
      t.boolean :mandatory
      t.string  :values

      t.timestamps
    end
  end

  def self.down
    drop_table :survey_questions
  end
end
