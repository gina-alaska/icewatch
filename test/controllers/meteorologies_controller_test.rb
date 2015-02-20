require 'test_helper'

class MeteorologiesControllerTest < ActionController::TestCase
  setup do
    @meteorology = meteorologies(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:meteorologies)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create meteorology' do
    assert_difference('Meteorology.count') do
      post :create, meteorology: { air_pressure: @meteorology.air_pressure, air_temperature: @meteorology.air_temperature, observation_id: @meteorology.observation_id, realtive_humidity: @meteorology.realtive_humidity, total_cloud_cover: @meteorology.total_cloud_cover, visibility_lookup_id: @meteorology.visibility_lookup_id, water_temperature: @meteorology.water_temperature, weather_lookup_id: @meteorology.weather_lookup_id, wind_direction: @meteorology.wind_direction, wind_speed: @meteorology.wind_speed }
    end

    assert_redirected_to meteorology_path(assigns(:meteorology))
  end

  test 'should show meteorology' do
    get :show, id: @meteorology
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @meteorology
    assert_response :success
  end

  test 'should update meteorology' do
    patch :update, id: @meteorology, meteorology: { air_pressure: @meteorology.air_pressure, air_temperature: @meteorology.air_temperature, observation_id: @meteorology.observation_id, realtive_humidity: @meteorology.realtive_humidity, total_cloud_cover: @meteorology.total_cloud_cover, visibility_lookup_id: @meteorology.visibility_lookup_id, water_temperature: @meteorology.water_temperature, weather_lookup_id: @meteorology.weather_lookup_id, wind_direction: @meteorology.wind_direction, wind_speed: @meteorology.wind_speed }
    assert_redirected_to meteorology_path(assigns(:meteorology))
  end

  test 'should destroy meteorology' do
    assert_difference('Meteorology.count', -1) do
      delete :destroy, id: @meteorology
    end

    assert_redirected_to meteorologies_path
  end
end
