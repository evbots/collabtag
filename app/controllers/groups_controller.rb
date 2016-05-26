class GroupsController < ApplicationController
  before_action :check_params_for_school, only: [:explore_school_group]
  before_action :create_sidebar_variables
  before_action :show_sidebar, except: [:explore]

  # GET
  # /explore
  def explore
    if session[:school_code].present? && params[:force] != 'true'
      redirect_to action: 'explore_school_group',
                  school_code: session[:school_code],
                  group: 'general'
    else
      # will only see if session is empty or force_choose = true
    end
  end

  # GET
  # /explore/:school_code
  def explore_school
    redirect_to action: 'explore_school_group',
                school_code: params[:school_code],
                group: 'general'
  end

  # GET
  # /explore/:school_code/:group
  def explore_school_group
    @group_name = params[:group]
    @group = Group.find_with_tag(@group_name, session[:school_code])
  end

  # POST
  # /explore/set_school
  def set_school
    school = School.find_by(name: params[:school][:school_select])

    redirect_to action: 'explore_school_group',
                school_code: school.code,
                group: 'general'
  end

  # GET
  # /account/typeahead_data
  def typeahead_data
    render json: File.open('app/assets/data/schools.json').read
  end

  private

  def check_params_for_school
    return unless params[:school_code].present? && (session[:school_code] != params[:school_code])
    school = School.find_by(code: params[:school_code])

    session[:school_code] = params[:school_code]
    session[:school_name] = school.display_name
    session[:school_id] = school.id
  end
end
