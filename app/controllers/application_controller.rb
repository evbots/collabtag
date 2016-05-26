class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_buster
  before_action :store_location
  before_action :define_user
  before_action :create_sidebar_variables

  def create_sidebar_variables
    return unless session[:school_id].present?
    @group_list = GroupList.default_list
    @school_code = session[:school_code]
    @school_name = session[:school_name]
  end

  def define_user
    @user = current_user if user_signed_in?
  end

  def raise_404
    # fail ActiveRecord::RecordNotFound
    raise ActionController::RoutingError.new('Not Found')
  end

  def store_location
    # store last url as long as it isn't a /account path
    if (request.format == "text/html" || request.content_type == "text/html") && request.get?
      session[:previous_url] = request.fullpath unless request.fullpath =~ /\/account/
    end
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url] || show_user_path(username: current_user.username)
  end

  def set_cache_buster
    if request.xhr? == 0
      response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      response.headers['Pragma'] = 'no-cache'
      response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    end
  end

  def show_sidebar
    @show_sidebar = true
  end

  def hide_sidebar
    @show_sidebar = false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
