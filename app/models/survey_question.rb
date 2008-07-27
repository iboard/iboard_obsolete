class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey
  has_many   :survey_answers
end
