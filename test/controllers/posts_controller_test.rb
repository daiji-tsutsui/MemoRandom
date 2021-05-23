require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @user = users(:one)
    @another = users(:two)
  end

  test "should restrict non-logged-in user access" do
    get top_url(@post)
    assert_response :success
    get post_url(@post)
    assert_response :success
    get new_post_url
    assert_redirected_to top_url
    get edit_post_url(@user)
    assert_redirected_to top_url
  end

end
