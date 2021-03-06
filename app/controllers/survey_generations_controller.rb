#
# SurveyGenerationsController
#
class SurveyGenerationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  #
  # Generate survey for a presentation using a survey template
  #
  def create
    set_instance_variables
    generate_survey_and_questions

    if @survey.valid? && Question.valid_collection?(@questions)
      @survey.save
      Question.save_collection(@questions, @survey)

      flash[:success] = 'A new survey has been added to the presentation.'
    else
      flash[:error] = 'A survey could not be created from the survey template'
    end

    redirect_to presentation_surveys_path(@presentation)
  end

  private

  #
  # Set instance variables
  #
  def set_instance_variables
    @presentation = Presentation.find_by(id: params[:presentation_id])
    @survey_template = SurveyTemplate.find_by(id: params[:survey_template_id])
  end

  #
  # Generate unsaved survey & its questions from templates
  #
  def generate_survey_and_questions
    @survey = Survey.build_from_template(@survey_template, @presentation)
    @questions = Question.build_from_templates(@survey_template.question_templates)
  end
end
