class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :finalize_signup, :facebook_signup]

  # Sidebar callbacks
  before_action :create_sidebar_variables
  before_action :show_sidebar, only: [:show, :edit, :edit_password, :notifications, :confirm_rm]
  before_action :hide_sidebar, only: [:facebook_signup, :finalize_signup]

  def show
    @user = User.find_by_username(params[:username])
    @profile_page = true
  end

  def edit
  end

  def edit_password
  end

  def update
    if @user.update(username: params[:user][:username],
                    first_name: params[:user][:first_name],
                    last_name: params[:user][:last_name],
                    location: params[:user][:location],
                    image_url: params[:user][:image_url])
      flash[:success] = 'User was successfully updated.'
    else
      flash[:error] = 'There was a problem updating the user.'
    end
    @user.reload
    redirect_to action: :edit, username: current_user.username
  end

  def update_password
    if @user.update_with_password(user_pass_params)
      sign_in @user, bypass: true
      redirect_to action: :edit
    else
      render action: :edit_password
    end
  end

  def confirm_rm
  end

  def destroy
    if @user.destroy
      flash[:error] = 'Sorry to see you go!'
      redirect_to new_user_registration_path
    else
      flash[:error] = 'There was an error deleting your account.'
      redirect_to action: :edit
    end
  end

  def notifications
  end

  def facebook_signup
    @show_email = session['facebook_data']['info']['email'].nil?
    @facebook_info = Facebook.new(email: session['facebook_data']['info']['email'])
  end

  def finalize_signup
    @show_email = session['facebook_data']['info']['email'].nil?
    user = User.finalize_signup(params[:facebook], session['facebook_data'])
    if user.valid?
      sign_in_and_redirect user, event: :authentication
    else
      @errors = user.errors.messages
      @facebook_info = Facebook.new(email: user.email, username: user.username)
      render :facebook_signup
    end
  end

  def refresh_facebook_image
    current_user.image_url = ''
    current_user.save
    redirect_to action: :edit
  end

  private

  def user_params
    params[:user]
  end

  def user_pass_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
