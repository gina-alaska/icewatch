require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
  end

  test 'should create comment' do
    assert_difference('Comment.count') do
      xhr :post, :create, observation_id: @comment.observation.id, format: :js, comment: {
        person_id_or_name: @comment.person_id,
        text: @comment.text
      }
    end

    assert_response :success
  end

  test 'should get edit' do
    xhr :post, :edit, id: @comment, format: :js
    assert_response :success
  end

  test 'should update comment' do
    patch :update, id: @comment, observation_id: @comment.observation.id, format: :js, comment: {
      person_id_or_name: @comment.person_id,
      text: @comment.text
    }

    assert_response :success
  end

  test 'should destroy comment' do
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end

    assert_redirected_to observation_path(@comment.observation)
  end
end
