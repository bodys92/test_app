require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "Invalid sign up" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "",
                                        email:"testmail.com",
                                        password:"testpass",
                                        password_confirmation:"testpass"}}
    end

    assert_template 'users/new'
  
  end

  test "Valid sign up" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: "Rails Tutorial",
                                        email:"example@railstutorial.org",
                                        password:"password",
                                        password_confirmation:"password"}}
    end

    follow_redirect!
    assert_template 'users/show'
  
  end
end
