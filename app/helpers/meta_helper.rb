module MetaHelper
  def combined_meta_tags(params = {})
    out = standard_meta_tags(params)
    out << og_meta_tags(params)
    out << twitter_meta_tags(params)
  end

  def standard_meta_tags(params = {})
    out = tag('meta', name: 'description', content: params[:description].to_s)
    out << tag('meta', name: 'keywords', content: params[:keywords].to_s)
  end

  def og_meta_tags(params = {})
    out = tag('meta', property: 'og:title', content: params[:title].to_s)
    out << tag('meta', property: 'og:type', content: 'website')
    out << tag('meta', property: 'og:url', content: params[:url].to_s)
    out << tag('meta', property: 'og:image', content: asset_url(params[:image].to_s))
    out << tag('meta', property: 'og:image:height', content: '150')
    out << tag('meta', property: 'og:image:width', content: '150')
    out << tag('meta', property: 'og:description', content: params[:description].to_s)
    out << tag('meta', property: 'og:site_name', content: 'collabtag')
  end

  def twitter_meta_tags(params = {})
    out = tag('meta', name: 'twitter:card', content: 'summary')
    out << tag('meta', name: 'twitter:site', content: '@collabtag')
    out << tag('meta', name: 'twitter:title', content: params[:title].to_s)
    out << tag('meta', name: 'twitter:description', content: params[:description].to_s)
    out << tag('meta', name: 'twitter:image', content: asset_url(params[:image].to_s))
    out << tag('meta', name: 'twitter:url', content: params[:url].to_s)
  end
end
