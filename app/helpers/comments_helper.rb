module CommentsHelper
  def comment_error message
    content_tag :div, message, class: 'alert alert-danger'
  end
end
