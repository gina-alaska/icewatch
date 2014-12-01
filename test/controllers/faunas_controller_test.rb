require 'test_helper'

class FaunasControllerTest < ActionController::TestCase
  setup do
    @fauna = faunas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faunas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fauna" do
    assert_difference('Fauna.count') do
      post :create, fauna: { count: @fauna.count, name: @fauna.name, observation_id: @fauna.observation_id }
    end

    assert_redirected_to fauna_path(assigns(:fauna))
  end

  test "should show fauna" do
    get :show, id: @fauna
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fauna
    assert_response :success
  end

  test "should update fauna" do
    patch :update, id: @fauna, fauna: { count: @fauna.count, name: @fauna.name, observation_id: @fauna.observation_id }
    assert_redirected_to fauna_path(assigns(:fauna))
  end

  test "should destroy fauna" do
    assert_difference('Fauna.count', -1) do
      delete :destroy, id: @fauna
    end

    assert_redirected_to faunas_path
  end
end
