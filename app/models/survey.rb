class Survey < ActiveRecord::Base
  has_many :survey_questions
  has_many :survey_answers, :through => :survey_questions
  has_many :users, :through => :survey_answers
  
  
  def add_question(new_question,new_question_values,question_type)
    s = SurveyQuestion.create( :survey_id => self.id,
                           :question  => new_question,
                           :qtype      => question_type.to_i,
                           :values    => new_question_values )  
  end
  
end
