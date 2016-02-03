require 'test_helper'

class AdminWorkflowTest < ActionDispatch::IntegrationTest
  def teardown
    logout
  end

  def test_admins_can_delete_users
    guest = users(:guest)
    admin = users(:admin)

    login(:admin)

    visit(users_path)

    within("#row_user_#{admin.id}") do
      refute page.has_content?("Delete")
    end
    
    within("#row_user_#{guest.id}") do
      click_link("Delete")
    end

    assert page.has_content?("User #{guest} deleted.")
    refute page.has_content?("#row_user_#{guest.id}")
  end
end
