require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @test_user = users(:tester)
    @micropost = @test_user.microposts.build(content:"Lorem ipsum")
  end

  test "valid micropost" do
    assert @micropost.valid?
  end

  test "non valid micropost" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "black content" do
    @micropost.content = "     "
    assert_not @micropost.valid?
  end

  test "too long content" do
    text = "a" * 141
    @micropost.content = text
    assert_not @micropost.valid?
  end

  test "order should be recent first" do
    assert_equal microposts(:first_post), Micropost.first
  end
end


