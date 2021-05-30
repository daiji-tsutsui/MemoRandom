require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @post = posts(:one)
    @post_by_another = posts(:two)
    @user = users(:one)
    @another = users(:two)
    @memo = fixture_file_upload('test/fixtures/files/dummy.pdf')
    @readme= posts(:readme)
  end

  test "should restrict non-logged-in user access" do
    get top_url
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
    follow_redirect!
    get edit_post_url(@post_by_another)
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
  end

  test "should create post" do
    log_in_as(@user)
    follow_redirect!
    assert_difference('Post.count', 1) do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: [@memo] } }
    end
    # assert_redirected_to post_url(Post.last)
    assert_redirected_to top_url
    assert flash[:success].instance_of?(Array)
    assert_equal 0, flash[:danger].size
    assert_equal @user.id, Post.last.user_id
  end

  test "should not create invalid post" do
    log_in_as(@user)
    follow_redirect!
    assert_no_difference('Post.count') do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: [""] } }
    end
    assert_redirected_to new_post_url
    assert_equal 0, flash[:success].size
    assert flash[:danger].instance_of?(Array)
  end

  test "should not create when not logged in" do
    assert_no_difference('Post.count') do
      post new_post_url, params: { post: {
                  name: "test_post",
                  memo: [@memo] } }
    end
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
  end

  test "should update post" do
    log_in_as(@user)
    follow_redirect!
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to post_url(@post)
    assert flash[:success].instance_of?(String)
    assert flash[:danger].nil?
    assert_equal "new_name", @post.reload.name
  end

  test "should not update when not logged in" do
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
    assert_not_equal "new_name", @post.reload.name
  end

  test "should not update by incorrect user" do
    log_in_as(@another)
    follow_redirect!
    patch post_url(@post), params: { post: {
                  name: "new_name",
                  memo: @memo } }
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
    assert_not_equal "new_name", @post.reload.name
  end

  test "should delete post" do
    log_in_as(@user)
    follow_redirect!
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end
    assert_redirected_to top_url
    assert flash[:success].instance_of?(String)
    assert flash[:danger].nil?
  end

  test "should not delete when not logged in" do
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
  end

  test "should not delete by incorrect user" do
    log_in_as(@another)
    follow_redirect!
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end
    assert_redirected_to top_url
    assert flash[:success].nil?
    assert flash[:danger].instance_of?(String)
  end

  test "should show readme" do
    post readme_url, params: {}
    assert_redirected_to @readme
  end

  test "should search readme" do
    log_in_as(@user)
    post new_post_url, params: { post: {
                name: "README",
                memo: [@memo] } }
    post readme_url, params: {}
    assert_redirected_to top_path(word: 'readme')
    follow_redirect!
    assert_select "a span.text-danger", count: 2
  end
end
