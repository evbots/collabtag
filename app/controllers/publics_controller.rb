class PublicsController < ApplicationController
  layout 'landing'

  def index
    redirect_to show_user_path(current_user.username) if user_signed_in?
  end
end
