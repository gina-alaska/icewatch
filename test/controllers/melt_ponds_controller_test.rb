require 'test_helper'

class MeltPondsControllerTest < ActionController::TestCase
  setup do
    @melt_pond = melt_ponds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:melt_ponds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create melt_pond" do
    assert_difference('MeltPond.count') do
      post :create, melt_pond: { bottom_type_lookup_id: @melt_pond.bottom_type_lookup_id, dried_ice: @melt_pond.dried_ice, freeboard: @melt_pond.freeboard, ice_observation_id: @melt_pond.ice_observation_id, max_depth_lookup_id: @melt_pond.max_depth_lookup_id, pattern_lookup_id: @melt_pond.pattern_lookup_id, rotten_ice: @melt_pond.rotten_ice, surface_coverage: @melt_pond.surface_coverage, surface_lookup_id: @melt_pond.surface_lookup_id }
    end

    assert_redirected_to melt_pond_path(assigns(:melt_pond))
  end

  test "should show melt_pond" do
    get :show, id: @melt_pond
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @melt_pond
    assert_response :success
  end

  test "should update melt_pond" do
    patch :update, id: @melt_pond, melt_pond: { bottom_type_lookup_id: @melt_pond.bottom_type_lookup_id, dried_ice: @melt_pond.dried_ice, freeboard: @melt_pond.freeboard, ice_observation_id: @melt_pond.ice_observation_id, max_depth_lookup_id: @melt_pond.max_depth_lookup_id, pattern_lookup_id: @melt_pond.pattern_lookup_id, rotten_ice: @melt_pond.rotten_ice, surface_coverage: @melt_pond.surface_coverage, surface_lookup_id: @melt_pond.surface_lookup_id }
    assert_redirected_to melt_pond_path(assigns(:melt_pond))
  end

  test "should destroy melt_pond" do
    assert_difference('MeltPond.count', -1) do
      delete :destroy, id: @melt_pond
    end

    assert_redirected_to melt_ponds_path
  end
end
