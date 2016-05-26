class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  attr_accessor :login
  has_many :posts, dependent: :destroy
  has_many :feedbacks
  has_many :notifications
  has_many :group_lists
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: /\A([a-z0-9_.]{1,18}\z)(?<!^posts$|^account$|^explore$)/,
                                 message: 'must be under 18 characters in length containing only letters, numbers, underscores, and periods. Additionally, some usernames are reserved.' }

  def brand_new?
    sign_in_count <= 1 && 5.minutes.ago < last_sign_in_at
  end

  def self.facebook_account?(auth)
    find_by(facebook_uid: auth['uid'])
  end

  def self.basic_account?(auth)
    find_by(email: auth['info']['email'])
  end

  def self.merge_fb_into_user(auth)
    existing = find_by(email: auth['info']['email'])
    existing.facebook_uid = auth['uid']
    existing.save
    existing
  end

  def self.finalize_signup(form, auth)
    new_email = auth.fetch('info', {}).fetch('email', nil) || form['email']
    create(email: new_email,
           password: Devise.friendly_token[0, 20],
           username: form['username'],
           facebook_uid: auth['uid'])
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def full_name
    if first_name && last_name
      first_name + ' ' + last_name
    elsif first_name && last_name.blank?
      first_name
    elsif last_name && first_name.blank?
      last_name
    else
      ''
    end
  end
end
