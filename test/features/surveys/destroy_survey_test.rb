require 'test_helper'

class DestroySurveyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  feature 'Destroy' do
    scenario 'clicking "Delete Survey" as admin deletes the survey' do
      admin = create(:user, :admin)
      presentation = create(:presentation)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(admin, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Delete Survey'

      refute(page.has_content?(survey.title))
    end

    scenario 'clicking "Delete Survey" as presenter deletes the survey' do
      presenter = create(:user)
      presentation = create(:presentation)
      create(:participation, :presenter,
             user_id: presenter.id,
             presentation_id: presentation.id)
      survey = create(:survey, presentation_id: presentation.id)

      login_as(presenter, scope: :user)

      visit presentation_surveys_path(presentation)

      click_on 'Delete Survey'

      refute(page.has_content?(survey.title))
    end

    scenario 'a presenter cannot delete another presenters survey' do
      presenter1 = create(:user)
      presenter2 = create(:user)

      presentation = create(:presentation)

      create(:participation, :presenter,
             user_id: presenter1.id,
             presentation_id: presentation.id)
      create(:participation, :presenter,
             user_id: presenter2.id,
             presentation_id: presentation.id)

      create(:survey,
             presentation_id: presentation.id,
             presenter_id: presenter2.id)

      login_as(presenter1, scope: :user)

      visit presentation_surveys_path(presentation)

      button = find_link('Delete Survey')

      assert(button[:class].include?('disabled'))
    end
  end
end
