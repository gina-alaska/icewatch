require 'test_helper'

class UploadedPhotosetsControllerTest < ActionController::TestCase
  setup do
    @uploaded_photoset = uploaded_photosets(:one)
  end

  test "should create uploaded_photoset" do
    assert_difference('UploadedPhotoset.count') do
      post :create, cruise_id: cruises(:cruise_0), uploaded_photoset: { file: fixture_file_upload('images/vegas.jpg', 'image/jpg') }
    end

  end

end
