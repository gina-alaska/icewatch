require 'test_helper'

class LookupsControllerTest < ActionController::TestCase
  setup do
    @lookup = lookups(:light)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:lookups)
  end

  test 'should show lookup' do
    get :show, id: @lookup
    assert_response :success
  end

end
