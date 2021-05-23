require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @another = users(:two)
  end

  test "should restrict non-logged-in user access" do
    get new_user_url
    assert_response :success
    get login_url
    assert_response :success
    get top_url
    assert_response :success
    get users_url
    assert_redirected_to top_url
    get user_url(@user)
    assert_redirected_to top_url
  end

  test "should get pages by logged-in user" do
    log_in_as(@user)
    get users_url
    assert_response :success
    get user_url(@user)
    assert_response :success
    get user_url(@another)
    assert_response :success
    get edit_user_url(@user)
    assert_response :success
    get delete_user_url(@user)
    assert_response :success
  end

  test "should not get private page as incorrect user" do
    log_in_as(@user)
    get edit_user_url(@another)
    assert_redirected_to users_url
    get delete_user_url(@another)
    assert_redirected_to users_url
  end

  test "should log in" do
    get login_url
    assert_response :success
    log_in_as(@user)
    assert_redirected_to user_url(@user)
    assert is_logged_in?
  end

  test "should not log in with invalid information" do
    invalid_user = User.new(name: "invalid_user")
    log_in_as(invalid_user)
    assert_not is_logged_in?

    log_in_as(@user, password: "")
    assert_not is_logged_in?
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { user: {
                  name: "test_user",
                  password: "foobar",
                  password_confirmation: "foobar" } }
    end
    assert_redirected_to user_url(User.last)
    assert is_logged_in?
  end

  test "should not create invalid user" do
    assert_no_difference('User.count') do
      post users_url, params: { user: {
                  name: "",
                  password: "foobar",
                  password_confirmation: "foobar" } }
    end
    assert_no_difference('User.count') do
      post users_url, params: { user: {
                  name: "test_user",
                  password: "aaaaa",
                  password_confirmation: "aaaaa" } }
    end
  end

  test "should update user" do
    log_in_as(@user)
    patch user_url(@user), params: { user: { name: "new_name" } }
    assert_equal @user.reload.name, "new_name"
    assert_redirected_to user_url(@user)
  end

  test "should not update another user" do
    log_in_as(@user)
    patch user_url(@another), params: { user: { name: "new_name" } }
    assert_not_equal @another.reload.name, "new_name"
    assert_redirected_to users_url
  end

  test "should destroy user" do
    log_in_as(@user)
    assert_difference('User.count', -1) do
      delete user_url(@user), params: { name_confirmation: @user.name }
    end
    assert_not is_logged_in?
    assert_redirected_to top_url
  end

  test "should not destroy user without confirmation" do
    log_in_as(@user)
    assert_no_difference('User.count') do
      delete user_url(@user), params: { name_confirmation: "not_name_of_user" }
    end
    assert is_logged_in?
  end

  test "should not destroy another user" do
    log_in_as(@user)
    assert_no_difference('User.count') do
      delete user_url(@another), params: { name_confirmation: @another.name }
    end
    assert is_logged_in?
  end

end
