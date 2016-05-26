class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if user_signed_in?
      # Request originated from edit profile page
      if request.env['omniauth.auth']['info']['email'].present?
        if current_user.email == request.env['omniauth.auth']['info']['email']
          # delete URL from source so facebook image is shown
          current_user.image_url = ''
          current_user.facebook_uid = request.env['omniauth.auth']['uid']
          current_user.save
          flash[:success] = 'Thanks! We\'ve made your Facebook profile picture the default.'
          redirect_to edit_user_path
        else
          flash[:error] = 'Your Collabtag and Facebook emails must match.'
          redirect_to edit_user_path
        end
      else
        flash[:error] = 'You must authorize Collabtag to see your Facebook email in order to verify your identity.'
        redirect_to edit_user_path
      end
    elsif user = User.facebook_account?(request.env['omniauth.auth'])
      # Previous FB account login.
      sign_in_and_redirect user, event: :authentication
    elsif User.basic_account?(request.env['omniauth.auth'])
      # Basic account already exists
      merged_user = User.merge_fb_into_user(request.env['omniauth.auth'])
      sign_in_and_redirect merged_user, event: :authentication
    else
      # Brand new FB collabtag account
      session['facebook_data'] = request.env['omniauth.auth']
      redirect_to facebook_signup_path
    end
  end
end
