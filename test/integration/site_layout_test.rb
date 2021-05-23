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
end
