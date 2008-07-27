class SurveysController < ApplicationController
  
  before_filter  :authenticate
  layout :get_application_layout
  
  # GET /surveys
  # GET /surveys.xml
  def index
    if granted_for?('root') || granted_for('survey')
      @surveys = Survey.find(:all,:include => [:survey_questions,:survey_answers])
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @surveys }
      end
    else
      access_denied
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      @survey = Survey.find(params[:id],:include => [:survey_questions,:survey_answers])
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @survey }
      end
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      @survey = Survey.new
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @survey }
      end
    end
  end

  # GET /surveys/1/edit
  def edit
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      @survey = Survey.find(params[:id],:include => [:survey_questions,:survey_answers])
    end
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      
      @survey = Survey.new(params[:survey])
      
      respond_to do |format|
        if @survey.save
          flash[:notice] = 'Survey was successfully created.'
          format.html { redirect_to(@survey) }
          format.xml  { render :xml => @survey, :status => :created, :location => @survey }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      
      @survey = Survey.find(params[:id])
      
      @survey.add_question(params[:new_question],
                           params[:new_question_values],
                           params[:question_type]) unless params[:new_question].blank?
      
      respond_to do |format|
        if @survey.update_attributes(params[:survey])
          flash[:notice] = 'Survey was successfully updated.'
          format.html { redirect_to( edit_survey_path(@survey)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      
      @survey = Survey.find(params[:id])
      @survey.destroy
      
      respond_to do |format|
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  def add_question
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      @surveys = Survey.find(params[:id])
      render :layout => false
    end
  end
  
  def destroy_question
    if not (granted_for?('root') || granted_for('survey'))
      access_denied
    else
      
      @survey_question = SurveyQuestion.find(params[:id])
      @survey = @survey_question.survey
      @survey_question.destroy
      redirect_to edit_survey_path(@survey)
    end
  end
  
  def answer
    if user
      @survey = Survey.find(params[:id],:include => [:survey_questions])
      @survey_questions = @survey.survey_questions
    else
      access_denied
    end
  end

  def save_answer
    @survey = Survey.find(params[:id], :include => [:survey_questions])
    question_id = params[:question_id].to_i
    @answers = []
    @survey.survey_questions.each do |q| 
      params[:answer].each_with_index do |a,i|
        if a[0].to_i == q.id.to_i
          @answer =   SurveyAnswer.find(:first,:conditions => ['user_id = ? and survey_question_id = ?', user.id, a[0].to_i ])
          @answer ||= SurveyAnswer.create(:user_id => user.id,:survey_question_id => a[0].to_i,
                                          :answer => a[1].split(",").join(", ") )
          @answer.answer = a[1].split(",").join(", ")
          @answer.save(false)
          @answers << @answer
        end
      end
    end
    
    
    @answer = []
    @survey.survey_questions.each do |question|
      @answer[question.id] = SurveyAnswer.find(:first,
        :conditions => ['user_id = ? and survey_question_id = ?', user.id, question.id])
      @answer[question.id] ||= SurveyAnswer.create( :user_id => user.id, 
                                            :survey_question_id => question.id,
                                            :answer => params[:answer])
    end
  end
  
  def results
    @survey = Survey.find(params[:id],:order => 'survey_question_id, survey_answers.answer', :include => [:survey_questions, :survey_answers])
    
  end

  
end
