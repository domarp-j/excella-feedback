#
# Question model
#
class Question < ApplicationRecord
  include QuestionHelper

  belongs_to :survey

  #
  # acts_as_list gem handles Question order based on parent Survey
  #
  acts_as_list scope: :survey

  has_many :responses, dependent: :destroy
  has_many :users, through: :responses, dependent: :destroy

  #
  # Values for Presentation survey questions
  #
  def self.default_presentation_questions
    [
      { prompt: 'I thought this course effectively taught the subject matter.',
        response_type: 'number' }, {
          prompt: 'I thought this course was relevant to my future projects.',
          response_type: 'number'
        }, {
          prompt: 'Do you have any additional comments?',
          response_type: 'text'
        }
    ]
  end

  #
  # Values for Presenter survey questions
  #
  def self.default_presenter_questions(presenter)
    [
      { prompt: "I thought #{presenter.full_name} effectively taught the subject matter.",
        response_type: 'number' }, {
          prompt: "I thought #{presenter.full_name} answered questions effectively.",
          response_type: 'number'
        }, {
          prompt: "Do you have any additional comments for #{presenter.full_name}?",
          response_type: 'text'
        }
    ]
  end

  #
  # Create questions from survey & question templates
  #
  def self.create_from_templates(survey:, question_templates:)
    question_templates.map do |question_template|
      survey.questions.new(
        prompt: question_template.prompt,
        response_type: question_template.response_type,
        response_required: question_template.response_required,
        position: survey.questions.maximum(:position) + 1
      )
    end
  end

  #
  # Check if all questions are valid
  #
  def self.vaid_collection?(questions)
    questions.each do |question|
      return false if question.invalid?
    end

    true
  end

  #
  # Save all questions in collection
  #
  def self.save_collection(questions)
    questions.each do |question|
      question.save!
    end
  end
end
