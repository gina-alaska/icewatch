ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_user(user_id)
    user = users(user_id)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Add helper method to log in a user
  def login(user)
    u = users(user)
    visit('/auth/developer')
    fill_in('Name', with: u.name)
    fill_in('Email', with: u.email)
    click_button('Sign In')
  end

  def logout
    visit('/')

    click_on('Welcome', exact: false)
    click_link('Logout')
  end
end