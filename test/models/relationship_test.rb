require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:testing).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "should follow and unfollow user" do
    testing = users(:testing)
    archer = users(:archer)
    assert_not testing.following?(archer)
    testing.follow(archer)
    assert testing.following?(archer)
    assert archer.followers.include?(testing)
    testing.unfollow(archer)
    assert_not testing.following?(archer)
  end
end
