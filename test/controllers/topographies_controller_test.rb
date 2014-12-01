require 'test_helper'

class TopographiesControllerTest < ActionController::TestCase
  setup do
    @topography = topographies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topographies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topography" do
    assert_difference('Topography.count') do
      post :create, topography: { concentration: @topography.concentration, ice_observation_id: @topography.ice_observation_id, old: @topography.old, ridge_height: @topography.ridge_height, snow_covered: @topography.snow_covered, topography_lookup_id: @topography.topography_lookup_id }
    end

    assert_redirected_to topography_path(assigns(:topography))
  end

  test "should show topography" do
    get :show, id: @topography
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topography
    assert_response :success
  end

  test "should update topography" do
    patch :update, id: @topography, topography: { concentration: @topography.concentration, ice_observation_id: @topography.ice_observation_id, old: @topography.old, ridge_height: @topography.ridge_height, snow_covered: @topography.snow_covered, topography_lookup_id: @topography.topography_lookup_id }
    assert_redirected_to topography_path(assigns(:topography))
  end

  test "should destroy topography" do
    assert_difference('Topography.count', -1) do
      delete :destroy, id: @topography
    end

    assert_redirected_to topographies_path
  end
end
