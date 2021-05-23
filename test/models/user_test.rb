require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "test user",
              password: "foobar",
              password_confirmation: "foobar")
    @user_one = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be long enough" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password should be confirmed" do
    @user.password = "foobarbaz"
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 256
    assert_not @user.valid?
  end

  test "name should be unique" do
    @another = @user.dup
    @user.save
    assert_not @another.valid?
  end

  test "post should be dependent on user" do
    num = @user_one.posts.length
    assert_not_equal 0, num
    assert_difference('Post.count', -num) do
      @user_one.destroy
    end
  end
end
