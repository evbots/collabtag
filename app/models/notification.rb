class Notification < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  belongs_to :user
  belongs_to :post
  serialize :metadata

  def self.create_for_user(user_object, poster, group_id, post_object)
    metadata = { kind: 'mention', trigger_id: poster.id, group_id: group_id.to_i }
    create(user: user_object, post: post_object, metadata: metadata)
  end

  def trigger_user
    User.find_by_id(metadata[:trigger_id])
  end

  def trigger_group
    Group.find_by_id(metadata[:group_id])
  end

  def post_body
    post.body if post
  end
end
