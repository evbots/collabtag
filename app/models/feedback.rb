class Feedback < ActiveRecord::Base
  belongs_to :user

  def self.new_entry(params, current_user)
    content = params['content']
    if content.blank?
      type, message = :error, 'Please enter a message.'
    elsif content.length > 20000
      type, message = :error, 'Please enter a shorter message.'
    else
      self.create(user: current_user, content: content)
      type, message = :success, 'Thanks for sending feedback!'
    end
    [type, message]
  end
end
