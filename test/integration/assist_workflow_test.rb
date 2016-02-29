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
          sleep 0.5
          # FIXME: And now this one stopped working after working on a different branch
          assert has_css?('div.floe-size[disabled]'), "Floe Size div should be disabled for #{ice_observation.obs_type} #{ice_type}"
          assert has_css?('select.floe-size[readonly]', visible: false), "Floe Size select should be readonly for #{ice_observation.obs_type} #{ice_type}"

        end
      end
    end
  end
end
