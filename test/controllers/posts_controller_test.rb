require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @post_by_another = posts(:two)
    @user = users(:one)
    @another = users(:two)
    @memo = fixture_file_upload('test/fixtures/dummy.pdf')
  end

  test "should restrict non-logged-in user access" do
    get top_url(@post)
    assert_response :success
    get post_url(@post)
    assert_response :success
    get new_post_url
    assert_redirected_to top_url
    get edit_post_url(@post)
    assert_redirected_to top_url
  end

  test "should get pages by logged-in user" do
    log_in_as(@user)
    get new_post_url
    assert_response :success
    get edit_post_url(@post)
    assert_response :success
  end

  test "should not get private page as incorrect user" do
    log_in_as(@user)
    get edit_post_url(@post_by_another)
    assert_redirected_to top_url
  end

  test "should create post" do
    log_in_as(@user)
    assert_difference('Post.count', 1) do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: @memo } }
    end
    assert_redirected_to post_url(Post.last)
    assert_equal @user.id, Post.last.user_id
  end

  test "should not create invalid post" do
    log_in_as(@user)
    assert_no_difference('Post.count') do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: "" } }
    end
  end

  test "should not create when not logged in" do
    assert_no_difference('Post.count') do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: @memo } }
    end
  end

  test "should update post" do
    log_in_as(@user)
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to post_url(@post)
    assert_equal "new_name", @post.reload.name
  end

  test "should not update when not logged in" do
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to top_url
    assert_not_equal "new_name", @post.reload.name
  end

  test "should not update by incorrect user" do
    log_in_as(@another)
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to top_url
    assert_not_equal "new_name", @post.reload.name
  end

  test "should delete post" do
    log_in_as(@user)
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
    assert_redirected_to top_url
  end

  test "should not delete when not logged in" do
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end
    assert_redirected_to top_url
  end

  test "should not delete by incorrect user" do
    log_in_as(@another)
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end
    assert_redirected_to top_url
  end
end
