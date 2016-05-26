module ApplicationHelper
  def explore_specific
    @school_name.upcase if @school_name
  end

  def explore_navbar
    @school_name.titleize if @school_name
  end

  def user_image_url(user)
    if user.image_url.present?
      out = user.image_url
    elsif user.facebook_uid
      response = JSON.parse(Typhoeus.get("graph.facebook.com/v2.5/#{user.facebook_uid}/picture?width=300&height=300&redirect=false", followlocation: true).body)
      image_uri = response['data']['url'].blank? ? 'tophat.png' : response['data']['url']
      out = image_url(image_uri)
    else
      out = image_url('tophat.png')
    end
    out
  end

  def profile_pic_help(user, style, optional_class = '')
    case style
    when :profile
      settings = 'width: 150px; height: 150px; margin-bottom: 15px;'
    when :account
      settings = 'width: 150px; height: 150px; margin-bottom: 10px; margin-top: 10px;'
    when :edit_page
      settings = 'width: 150px; height: 150px; margin-bottom: 10px; margin-top: 10px;'
    when :request
      settings = 'width: 150px; height: 150px;'
    when :members
      settings = 'width: 100px; height: 100px;'
    when :new_post
      settings = 'width: 64px; height: 64px;'
    end

    class_set = 'img-circle ' + optional_class
    class_set += ' center-block' unless style == :new_post || style == :edit_page
    if user.image_url.present?
      image_tag(user.image_url, class: class_set, id: 'profile_pic_edit', style: settings)
    elsif user.facebook_uid
      response = JSON.parse(Typhoeus.get("graph.facebook.com/v2.5/#{user.facebook_uid}/picture?width=300&height=300&redirect=false", followlocation: true).body)
      image_url = response['data']['url'].blank? ? 'tophat.png' : response['data']['url']
      image_tag(image_url, class: class_set, id: 'profile_pic_edit', style: settings)
    else
      image_tag('tophat.png', class: class_set, id: 'profile_pic_edit', style: settings)
    end
  end
end
