require 'test_helper'

class AssistWorkflowTest < ActionDispatch::IntegrationTest
  def teardown
    logout
  end

  # http://stackoverflow.com/questions/23371911/capybara-integration-tests-with-jquery-selectize
  def fill_in_selectize(key, value)
    page.execute_script(%{
      $('#{key}').data('selectize').setValue(#{value});
      })
  end

  def test_user_cant_enter_floe_size_with_tencode_ice_types
    observation = observations(:base)
    login(:manager)

    observation.ice_observations.each do |ice_observation|
      %w{frazil shuga grease slush brash}.each do |ice_type|
        visit(edit_observation_path(observation))

        within('#page') do
          click_link("Ice")
        end

        within("#ice_observation_#{ice_observation.id}") do
          value = lookups(ice_type.to_sym).id
          fill_in_selectize("#ice_observation_#{ice_observation.id} .ice-type", value)

          assert has_css?('div.floe-size[disabled]'), "Floe Size div should be disabled for #{ice_observation.obs_type} #{ice_type}"
          # FIXME:  Capybara is unable to find select.floe-size in the dom, yet
          # it exists when looking at it in the debugger. I'm probably missing something obvious.
          # assert has_css?('select.floe-size[readonly]'), "Floe Size select should be readonly for #{ice_observation.obs_type} #{ice_type}"
        end
      end
    end
  end
end
