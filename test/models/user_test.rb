require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @test_user = User.new(name: "Testovaci Uzivatel", email: "testing@mail.com",
                          password:"testheslo", password_confirmation: "testheslo")
  end

  test "validity test" do
    assert @test_user.valid?
  end

  test "name should be present" do
    @test_user.update_attribute(:name, "      ")
    assert_not @test_user.valid?
  end

  test "email should be present" do
    @test_user.email = "    "
    assert_not @test_user.valid?
  end

  test "name should not be too long" do
    @test_user.name = "a" * 51
    assert_not @test_user.valid?
  end

  test "email should not be too long" do
    @test_user.email = "a" * 247 + "@mail.com"
    assert_not @test_user.valid?
  end

  test "correct adresses" do
    valid_adresses = %w[user@example.com UsEr@mail.net A_US-CS@mail.server.cz first.last@foo.jp alena+milan@seznam.co.UK]
    valid_adresses.each do |address|
      @test_user.email = address
      assert @test_user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "incorrect adresses" do
    valid_adresses = %w[user@example,com UsEr@mail. A:US_CS@mail.server.cz first.last@foo+bar.jp alena+milan@seznam.co..UK]
    valid_adresses.each do |address|
      @test_user.email = address
      assert_not @test_user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "duplicate user" do
    dup_user = @test_user.dup
    dup_user.email = @test_user.email.upcase
    @test_user.save
    assert_not dup_user.valid?
  end

  test "email addresses shold be saved as lower-case" do
    non_fixed_email = "tEsTinG@mAIl.cOm"
    @test_user.email = non_fixed_email
    @test_user.save
    assert_equal non_fixed_email.downcase, @test_user.email
  end
  
  test "password should be present and nonblank" do
    @test_user.update_attributes(password:" " * 6, password_confirmation:" " * 6)
    assert_not @test_user.valid?
  end

  test "password should not be too small" do
    @test_user.password = @test_user.password_confirmation = "a" * 5
    assert_not @test_user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @test_user.authenticated?(:remember, '')
  end

  test "asociated micropost should be destroyed" do 
    @test_user.save
    @test_user.microposts.create!(content: "tester rad pise posty")
    assert_difference 'Micropost.count', -1 do
      @test_user.destroy
    end
  end

  test "should follow and unfollow a user" do
    test_user = users(:tester)
    other_user = users(:zoom)
    assert_not test_user.following?(other_user)
    test_user.follow(other_user)
    assert other_user.followers.include?(test_user)
    assert test_user.following?(other_user)
    test_user.unfollow(other_user)
    assert_not test_user.following?(other_user)
  end

  test "feed should have the right posts" do
    tester = users(:tester)
    followed_user = users(:flash)
    unfollowed_user = users(:zoom)
    tester.microposts.each do |post|
      assert tester.feed.include?(post)
    end
    followed_user.microposts.each do |post|
      assert tester.feed.include?(post)
    end
    unfollowed_user.microposts.each do |post|
      assert_not tester.feed.include?(post)
    end
  end

end