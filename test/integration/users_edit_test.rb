require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:tester)
  end

  test "Users edit with invalid values" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "",
                                            email: "invalid@mail",
                                            password: "pass",
                                            password_confirmation: "word"}}
    assert_template 'users/edit'
  end

  test "succesful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Super Tester"
    email = "valid@mail.com"
    patch user_path(@user), params: {user: {name: name,
                                            email: email,
                                            password: "",
                                            password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end    

  test "edit without login" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
end
