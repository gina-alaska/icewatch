require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should validate_inclusion_of(:role).in?(User::ROLES)
  should validate_presence_of(:role)

  def test_admin_cannot_be_deleted
    refute users(:admin).destroy, "Deleted admin user!"
  end
end
