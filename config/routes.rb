Rails.application.routes.draw do
  root to: 'publics#index'

  scope '/account' do
    get '',                          to: 'users#edit',                      as: :edit_user
    get 'edit_password',             to: 'users#edit_password',             as: :edit_user_password
    get 'confirm_del',               to: 'users#confirm_rm',                as: :confirm_user_delete
    get 'invites',                   to: 'users#invites',                   as: :user_invite_pending
    patch '',                        to: 'users#update',                    as: :update_user
    patch 'edit_password',           to: 'users#update_password',           as: :update_user_password
    delete 'delete',                 to: 'users#destroy',                   as: :destroy_user
    get 'feedback',                  to: 'feedback#view_form',              as: :view_feedback_form
    post 'save_feedback',            to: 'feedback#save_form',              as: :save_feedback_form
    get 'notifications',             to: 'users#notifications',             as: :view_notifications
    get 'facebook_signup',           to: 'users#facebook_signup',           as: :facebook_signup
    post 'finalize_signup',          to: 'users#finalize_signup',           as: :finalize_signup
    get 'refresh_facebook_image',    to: 'users#refresh_facebook_image',    as: :refresh_facebook_image
    get 'facebook_signup_from_edit', to: 'users#facebook_signup_from_edit', as: :facebook_signup_edit

    get 'typeahead_data', to: 'groups#typeahead_data', as: :typeahead_data
  end

  devise_for :users, path: 'account',
                     skip: [:registrations],
                     path_names: { sign_in: 'login',
                                   sign_out: 'logout',
                                   password: 'secret',
                                   confirmation: 'verification',
                                   unlock: 'unblock',
                                   registration: 'register',
                                   sign_up: 'cmon_let_me_in' },
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    scope '/account' do
      get 'register/cmon_let_me_in', to: 'devise/registrations#new', as: 'new_user_registration'
      post 'register', to: 'devise/registrations#create', as: 'user_registration'
      # get '/settings', to: 'devise/registrations#edit', as: 'edit_user_registration'
      # put '/settings', to: 'devise/registrations#update'
      # account deletion
      # delete '', to: 'devise/registrations#destroy'
    end
  end

  resources :posts, only: [:create, :destroy] do
    match 'paginate', on: :collection, via: [:get]
    match 'paginate_profile', on: :collection, via: [:get]
  end

  scope '/explore' do
    get '', to: 'groups#explore', as: :explore_base
    get ':school_code', to: 'groups#explore_school', as: :explore_school
    get ':school_code/:group', to: 'groups#explore_school_group', as: :explore_school_group
    get ':school_code/all_groups', to: 'groups#all_groups', as: :explore_all_groups
    post 'set_school', to: 'groups#set_school', as: :set_school
  end

  get ':username', to: 'users#show', as: :show_user
end
