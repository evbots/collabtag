module PostsHelper
  def username_regex(post_text)
    matches = post_text.scan(/(?<!\w)@([a-z0-9_.]{1,18})/)
    matches.each do |match_array|
      username = match_array[0]
      post_text.gsub!(/(?<!\w)@#{Regexp.quote(username)}/, "<a href=\"/#{username}\">@#{username}</a>")
    end
    post_text.html_safe
  end
end
