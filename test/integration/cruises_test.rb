require 'test_helper'

class CruisesTest < ActionDispatch::IntegrationTest

  def test_users_can_download_cruise_metadata
    cruise = cruises(:cruise_0)
    visit(cruise_path(cruise))

    within("#cruise-about") do
      assert has_content?(cruise.captain)
      assert has_content?(cruise.chief_scientist)
      assert has_content?(cruise.primary_observer.name)
      assert has_content?(cruise.starts_at)
      assert has_content?(cruise.ends_at)
      assert has_content?(cruise.objective)
    end

    within("#cruise-metadata") do
      assert_equal cruise_path(cruise, :csv), find_link('CSV')[:href], "No link to Metadata as CSV"
      assert_equal cruise_path(cruise, :json), find_link('JSON')[:href], "No link to Metadata as JSON"
    end
  end

  def test_user_can_download_cruise_observations
    visit_cruise_and_download("CSV")
    visit_cruise_and_download("JSON")
    visit_cruise_and_download("GeoJSON")
  end

  def test_csv_output
    cruise = cruises(:cruise_0)
    visit(cruise_path(cruise, :csv))
    visit(cruise_observations_path(cruise, :csv))
  end

  def visit_cruise_and_download(as)
    cruise = cruises(:cruise_0)

    visit(cruise_path(cruise))
    within("#cruise-data") do
      path = cruise_observations_path(cruise, as.downcase.to_sym)
      assert_equal path, find_link(as)[:href], "No link to observation data as #{as}"
      click_link(as)

      # assert_response 'success', "Could not download #{as}"
    end
  end
end
