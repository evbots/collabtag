class PostsController < ApplicationController
  def paginate_profile
    @posts = Post.profile_posts(params)
    html = render_to_string(file: 'shared/_posts', formats: 'html', layout: false, locals: { show_tag: true })
    last_timestamp = @posts.length > 0 ? @posts.last.created_at.to_s : 'empty'

    render json: { html: html, last_timestamp: last_timestamp }, status: :ok
  end

  def paginate
    @posts = Post.group_posts(params)
    html = render_to_string(partial: 'shared/posts', formats: [:html], layout: false, locals: { show_tag: false })
    last_timestamp = @posts.length > 0 ? @posts.last.created_at.to_s : 'empty'

    render json: { html: html, last_timestamp: last_timestamp }, status: :ok
  end

  def create
    status, @posts = Post.create_single_post(params, current_user)
    html = render_to_string(file: 'shared/_posts', formats: 'html', layout: false, locals: { show_tag: false })
    last_timestamp = @posts.length > 0 ? @posts.last.created_at.to_s : 'empty'

    render json: { html: html, last_timestamp: last_timestamp }, status: status
  end

  def destroy
    post_id = 'none'
    if current_user
      post = Post.find_by_id(params[:id])
      post.destroy
      post_id = post.id
    end
    render json: { post_id: post_id }
  end
end
