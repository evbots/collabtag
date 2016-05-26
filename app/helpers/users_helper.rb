module UsersHelper
  def notification_text_output(notification)
    trigger_username = notification.trigger_user.username
    "<a href=\"/#{ trigger_username }\">@#{ trigger_username }</a> has mentioned you in a comment in <div class=\"tag-wrapper inline-type\">#{ notification_group_link(notification) }</div>
    #{notification_post_body(notification)}".html_safe
  end

  def notification_group_link(notification)
    link_to(explore_school_group_path(group: notification.trigger_group.tag, school_code: notification.trigger_group.school)) do
      notification.trigger_group.tag
    end
  end

  def notification_post_body(notification)
    "<br><span class=\"comment-quoted\"> \"#{notification.post_body}\" </span>".html_safe if notification.post_body
  end

  def display_errors(field, errors_hash)
    return unless errors_hash && errors_hash[field]
    content_tag(:span, "#{field.capitalize} #{errors_hash[field][0]}", class: 'error-block')
  end
end
