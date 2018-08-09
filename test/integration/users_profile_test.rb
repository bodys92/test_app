require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

def setup
  @test_user = users(:tester)
end

  test "profile display" do
    get user_path(@test_user)
    assert_template 'users/show'
    assert_select 'title', full_title(@test_user.name)
    assert_select 'h1', text: @test_user.name
    assert_select 'h1>img.gravatar'
    #response.body contains the full HTML source of the page (not just the page’s body)
    assert_match @test_user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @test_user.microposts.paginate(page:1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
