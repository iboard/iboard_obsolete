class Survey < ActiveRecord::Base
  has_many :survey_questions, :dependent => :destroy
  has_many :survey_answers, :through => :survey_questions, :dependent => :destroy
  has_many :users, :through => :survey_answers
  
  
  def add_question(new_question,new_question_values,question_type)
    s = SurveyQuestion.create( :survey_id => self.id,
                           :question  => new_question,
                           :qtype      => question_type.to_i,
                           :values    => new_question_values )  
  end
  
  def display_result_table(question)
    rc ="<table border=1 width=100%>" +
        "<tr><th>" + _('Answer') + "</th><th>" + _('Count') + "</th></tr>"
    
    answers = {}
    question.survey_answers.each do |a|      
      if not a.answer.include? "!map:HashWithIndifferentAccess"
        if not answers["#{a.answer}"].nil?
          answers["#{a.answer}"] += 1
        else
          answers["#{a.answer}"] = 1
        end
      end
    end
    
    answers.each_with_index do |a,k|
      rc += "<tr><td>#{a[0]}</td><td align=right>#{a[1]}</td></tr>\n"
    end
    
    rc += "</table>\n"
    return rc 
  end
  
end
