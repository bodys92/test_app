require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:tester).id,
                                    followed_id: users(:flash).id)
  end
  
  test "valid relationship" do
    assert @relationship.valid?
  end

  test "relationship with invalid follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "relationship with invalid followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
