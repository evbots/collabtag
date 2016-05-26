class FeedbackController < ApplicationController
  before_action :authenticate_user!, only: [:view_form, :save_form]

  def view_form
  end

  def save_form
    type, message = Feedback.new_entry(feedback_params, current_user)
    flash[type] = message
    redirect_to action: :view_form
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end
