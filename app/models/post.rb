class Post < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_one :notification

  after_destroy { |record| record.notification.destroy if record.notification }

  def self.profile_posts(params)
    User.find_by(username: params[:user_name])
      .posts
      .order(created_at: :desc)
      .where('created_at < ?', assign_timestamp(params[:timestamp]))
      .take(10)
  end

  def self.group_posts(params)
    where(group_id: params[:group_id])
      .order(created_at: :desc)
      .where('created_at < ?', assign_timestamp(params[:timestamp]))
      .take(10)
  end

  def self.create_single_post(params, current_user)
    post = create(body: params[:body], group_id: params[:group_id], user: current_user)
    return [:not_found, {}] unless post
    check_post_for_usernames(params[:body], post, current_user, params[:group_id])
    [:ok, [post]]
  end

  def delete?(current_user)
    current_user && user == current_user
  end

  def self.delete?(post, current_user)
    current_user && post.user == current_user ? 'true' : 'false'
  end

  def self.assign_timestamp(timestamp)
    timestamp == '0' ? Time.zone.now : timestamp
  end

  def self.check_post_for_usernames(post_text, post_object, current_user, group_id)
    matches = post_text.scan(/(?<!\w)@([a-z0-9_.]{1,18})/)
    matches.each do |match_array|
      username = match_array[0]
      user = User.find_by_username(username)
      Notification.create_for_user(user, current_user, group_id, post_object) if user
    end
  end
end
