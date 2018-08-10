require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = users(:tester)
    @other_user = users(:zoom)
    log_in_as(@test_user)
  end

  test "following page" do
    get following_user_path(@test_user)
    assert_not @test_user.following.empty?
    assert_match @test_user.following.count.to_s, response.body
    @test_user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@test_user)
    assert_not @test_user.followers.empty?
    assert_match @test_user.followers.count.to_s, response.body
    @test_user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "should follow a user the standard way" do
    assert_difference '@test_user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@test_user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other_user.id }
    end
  end

  test "should unfollow a user the standard way" do
    @test_user.follow(@other_user)
    relationship = @test_user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@test_user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @test_user.follow(@other_user)
    relationship = @test_user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@test_user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end