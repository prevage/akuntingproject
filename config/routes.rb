
  Rails.application.routes.draw do


  authenticated :employee do
    root 'dashboards#index', as: 'dashboard'
  end

  root 'public_pages#main'
  
  get 'trade_center_info' => 'dashboards#trade_center_info', as: 'trade_center_info'
  get 'posted-shifts' => 'trade_center#all_posted_shifts', as: 'posted_shifts'
  get 'availability' => 'trade_center#all_availability', as: 'availability'
  get 'availability/date' => 'trade_center#available_on_date', as: 'available_on_date'
  get 'user_availability' => 'trade_center#user_availability', as: 'user_availability'
  get 'post_shift/:id' => 'trade_center#post_shift', as: 'post_shift'
  delete 'post-shifts/:id' => 'trade_center#cancel_shift', as: 'cancel_shift'
  get 'trade_with_collegue/:id' => 'trade_center#trade_with_collegue', as: 'collegue_trade'
  get 'trade_requests' => 'trade_center#trade_requests', as: 'trade_requests'
  get 'pending_requests' => 'trade_center#pending_requests', as: 'pending_requests'
  get 'employees' => 'profiles#all_employees', as: 'employees'
  get 'calendar' => 'calendar#index', as: 'calendar'
  post 'submit_shift' => 'trade_center#submit_shift', as: 'submit_shift'
  post 'pick_up_shift/:id/pickup', to:'trade_center#pick_up_shift', as: 'pick_up_shift'
  post 'set_user_availability' => 'trade_center#set_user_availability', as: 'set_user_availability'
 

  get 'shifts' => 'shifts#index', as: 'shifts'
  
  resources :bid_lines, only: [:index, :show]

  resources :posts
  devise_for :employees, :controllers => { :registrations => 'profile_account'}

  devise_scope :employee do
    as :employee do
      get '/signin' => 'devise/sessions#new'
      post 'signin' => 'devise/sessions#create'
      get '/signup' => 'devise/registrations#new'
      get '/profile/:id' => 'profile_account#edit', as: 'profile'
      put '/profile' => 'profile_account#update'
      delete '/signout' => 'devise/sessions#destroy'
    end
  end
  

