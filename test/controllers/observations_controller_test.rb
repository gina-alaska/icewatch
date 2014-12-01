require 'test_helper'

class ObservationsControllerTest < ActionController::TestCase
  setup do
    @observation = observations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:observations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create observation" do
    assert_difference('Observation.count') do
      post :create, observation: { cruise_id: @observation.cruise_id, latitude: @observation.latitude, longitude: @observation.longitude, observed_at: @observation.observed_at, uuid: @observation.uuid }
    end

    assert_redirected_to observation_path(assigns(:observation))
  end

  test "should show observation" do
    get :show, id: @observation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @observation
    assert_response :success
  end

  test "should update observation" do
    patch :update, id: @observation, observation: { cruise_id: @observation.cruise_id, latitude: @observation.latitude, longitude: @observation.longitude, observed_at: @observation.observed_at, uuid: @observation.uuid }
    assert_redirected_to observation_path(assigns(:observation))
  end

  test "should destroy observation" do
    assert_difference('Observation.count', -1) do
      delete :destroy, id: @observation
    end

    assert_redirected_to observations_path
  end
end
