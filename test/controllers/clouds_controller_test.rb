require 'test_helper'

class CloudsControllerTest < ActionController::TestCase
  setup do
    @cloud = clouds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clouds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud" do
    assert_difference('Cloud.count') do
      post :create, cloud: { cloud_lookup_id: @cloud.cloud_lookup_id, cloud_type: @cloud.cloud_type, cover: @cloud.cover, height: @cloud.height, meteorology_id: @cloud.meteorology_id }
    end

    assert_redirected_to cloud_path(assigns(:cloud))
  end

  test "should show cloud" do
    get :show, id: @cloud
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cloud
    assert_response :success
  end

  test "should update cloud" do
    patch :update, id: @cloud, cloud: { cloud_lookup_id: @cloud.cloud_lookup_id, cloud_type: @cloud.cloud_type, cover: @cloud.cover, height: @cloud.height, meteorology_id: @cloud.meteorology_id }
    assert_redirected_to cloud_path(assigns(:cloud))
  end

  test "should destroy cloud" do
    assert_difference('Cloud.count', -1) do
      delete :destroy, id: @cloud
    end

    assert_redirected_to clouds_path
  end
end
