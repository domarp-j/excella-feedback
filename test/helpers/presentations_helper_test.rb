require 'test_helper'

class PresentationsHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  before do
    @user = create(:user)

    @presentation_as_presenter = create(:presentation)
    @presentation_as_attendee = create(:presentation)

    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation_as_presenter.id,
      is_presenter: true
    )
    create(:participation,
      user_id: @user.id,
      presentation_id: @presentation_as_attendee.id,
      is_presenter: false
    )
  end

  describe '#presentations_as' do
    it 'gets correct presentations when current user is presenter' do
      presentations = presentations_as(:presenter, @user)

      assert_equal presentations, [@presentation_as_presenter]
    end

    it 'gets correct presentations where current user is attendee' do
      presentations = presentations_as(:attendee, @user)

      assert_equal presentations, [@presentation_as_attendee]
    end

    it 'returns an empty relation is role is not specified as presenter or attendee' do
      assert_equal presentations_as(:another_role, @user), []
    end

    it 'raises an error if role is not specified' do
      assert_raises(ArgumentError) { presentations_as(@user) }
    end

    it 'raises an error if user is not specified' do
      assert_raises(ArgumentError) { presentations_as(:presenter) }
    end
  end

  describe '#admin_table' do
    it 'tests pending...'
  end

  describe '#general_user_table' do
    it 'tests pending...'
  end

  describe '#feedback_header' do
    it 'tests pending...'
  end

  describe '#display_description' do
    it 'tests pending...'
  end

  describe '#feedback_content' do
    it 'tests pending...'
  end

  describe '#provide_feedback_button' do
    it 'shows provide feedback button if feedback has not been completed' do
      link_string = provide_feedback_button(@user, @presentation_as_attendee)

      assert link_string.include?('Provide Feedback'), 'Link does not include "Provide Feedback"'
      assert link_string.include?(new_presentation_response_path(@presentation_as_attendee)), 'Link does not include correct path'
    end

    it 'shows disabled feedback button when feedback completed' do
      presentation = create(:presentation)
      create(:participation,
             user_id: @user.id,
             presentation_id: presentation.id,
             is_presenter: false,
             feedback_provided: true)

      link_string = provide_feedback_button(@user, presentation)

      assert link_string.include?('disabled'), 'Link does not contain "disabled" class'
      assert link_string.include?('Feedback Submitted'), 'Link does not contain "Feedback Submitted"'
    end
  end

  describe '#feedback_button' do
    before do
      @see_feedback_text = 'See Feedback'
      @submitted_text = 'Feedback Submitted'
      @too_early_text = 'Available after Presentation'
      @disabled_css = 'disabled'

      @future_presentation = create(:presentation, :in_the_future)
      create(:participation,
             user_id: @user.id,
             presentation_id: @future_presentation.id,
             is_presenter: false)
    end
    it 'shows disabled button before presentation start time' do
      link_string = feedback_button(@user, @future_presentation)

      refute link_string.include?(@see_feedback_text), "Link contains '#{@see_feedback_text}'"
      refute link_string.include?(@submitted_text), "Link contains '#{@submitted_text}'"
      assert link_string.include?(@disabled_css), "Link does not contain '#{@disabled_css}' css class"
      assert link_string.include?(@too_early_text), "Link does not contain '#{@too_early_text}'"
    end

    it 'does not show any button on presentation#show before presentation start time' do
      params[:controller] = 'presentations'
      params[:action] = 'show'

      link_string = feedback_button(@user, @future_presentation)

      assert link_string.nil?, 'Displaying link when on presentation#show page before presentation start date'
    end

    it 'shows "See Feedback" button if user is presenter' do
      link_string = feedback_button(@user, @presentation_as_presenter)

      assert link_string.include?(@see_feedback_text), "Link does not contain '#{@see_feedback_text}'"
      assert link_string.include?(presentation_responses_path(@presentation_as_presenter)), 'Link does not include correct path'
    end

    it 'shows "See Feedback" button if admin is presenter' do
      link_string = feedback_button(@admin, @presentation_as_admin_presenter)

      assert link_string.include?('See Feedback'), 'Link does not contain "See Feedback"'
      assert link_string.include?(presentation_responses_path(@presentation_as_admin_presenter)), 'Link does not include correct path'
    end

    it 'does not show "See Feedback" button if user is not presenter' do
      link_string = feedback_button(@user, @presentation_as_attendee)

      refute link_string.include?(@see_feedback_text), "Link should not contain '#{@see_feedback_text}' "
    end
  end

  describe '#survey_link_for' do
    it 'tests pending...'
  end

  describe '#presentation_admin_options' do
    it 'tests pending...'
  end

  describe '#participation_table' do
    it 'tests pending...'
  end

  describe '#set_participation_table' do
    it 'tests pending...'
  end
end
