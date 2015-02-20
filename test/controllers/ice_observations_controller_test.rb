require 'test_helper'

class IceObservationsControllerTest < ActionController::TestCase
  setup do
    @ice_observation = ice_observations(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:ice_observations)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create ice_observation' do
    assert_difference('IceObservation.count') do
      post :create, ice_observation: { algae_density_lookup_id: @ice_observation.algae_density_lookup_id, algae_density_lookup_id: @ice_observation.algae_density_lookup_id, algae_lookup_id: @ice_observation.algae_lookup_id, floe_size_lookup_id: @ice_observation.floe_size_lookup_id, ice_lookup_id: @ice_observation.ice_lookup_id, obs_type: @ice_observation.obs_type, observation_id: @ice_observation.observation_id, partial_concentration: @ice_observation.partial_concentration, sediment_lookup_id: @ice_observation.sediment_lookup_id, snow_lookup_id: @ice_observation.snow_lookup_id, snow_thickness: @ice_observation.snow_thickness, thickness: @ice_observation.thickness }
    end

    assert_redirected_to ice_observation_path(assigns(:ice_observation))
  end

  test 'should show ice_observation' do
    get :show, id: @ice_observation
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @ice_observation
    assert_response :success
  end

  test 'should update ice_observation' do
    patch :update, id: @ice_observation, ice_observation: { algae_density_lookup_id: @ice_observation.algae_density_lookup_id, algae_density_lookup_id: @ice_observation.algae_density_lookup_id, algae_lookup_id: @ice_observation.algae_lookup_id, floe_size_lookup_id: @ice_observation.floe_size_lookup_id, ice_lookup_id: @ice_observation.ice_lookup_id, obs_type: @ice_observation.obs_type, observation_id: @ice_observation.observation_id, partial_concentration: @ice_observation.partial_concentration, sediment_lookup_id: @ice_observation.sediment_lookup_id, snow_lookup_id: @ice_observation.snow_lookup_id, snow_thickness: @ice_observation.snow_thickness, thickness: @ice_observation.thickness }
    assert_redirected_to ice_observation_path(assigns(:ice_observation))
  end

  test 'should destroy ice_observation' do
    assert_difference('IceObservation.count', -1) do
      delete :destroy, id: @ice_observation
    end

    assert_redirected_to ice_observations_path
  end
end
