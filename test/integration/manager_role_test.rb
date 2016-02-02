require 'test_helper'

class ManagerRoleTest < ActionDispatch::IntegrationTest
  def test_managers_can_approve_cruises
    login(:manager)

    visit(cruise_path(cruises(:test)))
    click_link('Approve Cruise')

    assert page.has_content?('Cruise has been approved')
  end

  def test_managers_can_approve_valid_observations
    login(:manager)

    visit(cruise_path(cruises(:cruise_2)))
    click_link('Approve Valid Observations')

    assert page.has_content?('Approved all valid observations')
  end

  def login(user)
    u = users(user)
    visit('/auth/developer')
    fill_in('Name', with: u.name)
    fill_in('Email', with: u.email)
    click_button('Sign In')
    # page.driver.post '/auth/developer/callback', name: u.name, email: u.email
    # page.driver.follow_redirect!
  end


end

#
# can :approve, Cruise
# can :approve_observations, Cruise
# can :approve, Observation
# can :edit, Observation
# can :read, User