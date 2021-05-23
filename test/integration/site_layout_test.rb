require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @another = users(:two)
  end

  test "layout links in top page" do
    get root_path
    assert_template 'posts/top'
    assert_template 'layouts/_header'
    assert_template 'layouts/_footer'
    assert_template 'shared/_error_messages'

    log_in_as(@user)
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1

    log_out
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "layout links in user page" do
    log_in_as(@user)
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user), count: 1
    assert_select "a[href=?]", edit_user_path(@another), count: 0
    assert_select "a[href=?]", users_path, count: 2

    get user_path(@another)
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@another), count: 0
    assert_select "a[href=?]", users_path, count: 2
  end

  test "delete post links in top page" do
    get root_path
    assert_select "a span.text-danger", count: 0

    log_in_as(@user)
    get root_path
    num1 = @user.posts.all.length
    assert_select "a span.text-danger", count: num1
    log_out

    log_in_as(@another)
    get root_path
    num2 = @another.posts.all.length
    assert_select "a span.text-danger", count: num2
  end

  test "delete post links in user page" do
    get user_path(@user)
    assert_select "a span.text-danger", count: 0

    log_in_as(@user)
    get user_path(@user)
    num1 = @user.posts.all.length
    assert_select "a span.text-danger", count: num1
    log_out

    log_in_as(@another)
    get user_path(@user)
    assert_select "a span.text-danger", count: 0
  end
end
