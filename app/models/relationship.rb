class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # validates :follower_id, uniqueness: true
  # validates :followed_id, uniqueness: true
end
