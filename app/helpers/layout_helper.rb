module LayoutHelper
  def class_if_sidebar
    'sidebar' if @show_sidebar
  end

  def show_flash?(flash)
    flash[:error] || flash[:success] || flash[:alert] || flash[:notice]
  end

  def flash_class(flash)
    if flash[:success]
      'alert-success'
    elsif flash[:error]
      'alert-danger'
    elsif flash[:alert]
      'alert-warning'
    elsif flash[:notice]
      'alert-info'
    else
      ''
    end
  end

  def flash_message(flash)
    [:success, :error, :alert, :notice].each do |type|
      return flash[type] if flash[type]
    end
    ''
  end
end
