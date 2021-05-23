require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @post = Post.new(name: "test_post",
                memo: open("#{Rails.root}/app/assets/images/dummy.pdf"),
                user_id: 1)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "name can be vacant" do
    @post.name = ""
    assert @post.valid?
  end

  test "memo should be a file" do
    @post.memo = "Not_file_but_sentence"
    assert_not @post.valid?
  end

  test "name should not be too long" do
    @post.name = "a" * 256
    assert_not @post.valid?
  end
end
