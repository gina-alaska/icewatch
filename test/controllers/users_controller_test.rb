require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_destroy_users 
    login_user(users(:admin))

    assert_difference('User.count', -1) do
      delete :destroy, id: users(:manager)
    end

    assert_no_difference('User.count') do
      delete :destroy, id: users(:admin)
    end

    assert_redirected_to users_path
  end
end
