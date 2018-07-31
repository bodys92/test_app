require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def setup
    @app_email = "noreply@example.com"
  end

  test "account_activation" do
    user = users(:tester)
    user.activation_token = User.token_new
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation example.com", mail.subject
    assert_equal [user.email], mail.to
    assert_equal [@app_email], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
