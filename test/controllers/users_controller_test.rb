require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = users(:tester)
    @other_user = users(:flash)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "update without login" do
    patch user_path(@test_user), params: {user: {name: @test_user.name,
                                            email: @test_user.email}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end  

  test "user edit wrong user" do
    log_in_as(@test_user)
    get edit_user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "user update wrong user" do
    log_in_as(@test_user)
    patch user_path(@other_user), params: {user: {name: @test_user.name,
                                            email: @test_user.email}}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {user: {password: "",
                                                  password_confirmation: "",
                                                  admin: true}}
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
  assert_no_difference 'User.count' do 
    delete user_path(@test_user)
  end
  assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@test_user)
    end
  assert_redirected_to root_url
  end       
  
  test "should redirect following when not logged in" do
    get following_user_path(@test_user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@test_user)
    assert_redirected_to login_url
  end
  
end
