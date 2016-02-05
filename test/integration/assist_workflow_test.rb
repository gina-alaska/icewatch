require 'test_helper'

class AssistWorkflowTest < ActionDispatch::IntegrationTest
  def teardown
    logout
  end

  def test_user_cant_enter_floe_size_with_tencode_ice_types
    observation = observations(:base)
    login(:manager)

    visit(edit_observation_path(observation))

    within('#page') do
      click_link("Ice")
    end

    observation.ice_observations.each do |ice_observation|
      within("#ice_observation_#{ice_observation.id}") do
        %w{frazil shuga grease slush brash}.each do |ice_type|
          select(lookups(ice_type.to_sym).code_with_name, from: "Ice Type")
          assert_equal true, find('input[id=observation_ice_observations_attributes_0_id]')[:disabled]
        end
      end
    end
  end
end
