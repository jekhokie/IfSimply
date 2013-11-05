Ifsimply::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :confirmations => 'confirmations' }

  namespace :mercury do
    resources :images
  end

  scope '/mercury' do
    get ':type/:resource'        => "mercury#resource"
    get 'snippets/:name/options' => "mercury#snippet_options"
    get 'snippets/:name/preview' => "mercury#snippet_preview"
  end

  root :to => 'home#index'

  scope '/' do
    match '/registration_notify' => 'home#registration_notify', :as => :registration_notify
    match '/access_violation'    => 'home#access_violation',    :as => :access_violation
  end

  # paypal-related routing
  scope '/adaptive_payments' do
    match '/preapproval' => 'paypal_transactions#preapproval', :as => :paypal_preapproval
  end

  # mercury editor routes
  get '/editor/blogs/:id'                 => "blogs#edit",             :as => :blog_editor
  get '/editor/clubs/:id'                 => "clubs#edit",             :as => :club_editor
  get '/editor/clubs/:club_id/sales_page' => "sales_pages#edit",       :as => :sales_page_editor
  get '/editor/courses/:id'               => "courses#edit",           :as => :course_editor
  get '/editor/discussion_boards/:id'     => "discussion_boards#edit", :as => :discussion_board_editor
  get '/editor/users/:id'                 => "users#edit",             :as => :user_editor

  resources :users, :only => [ :show, :update ] do
    member do
      # handle PayPal verification
      get 'specify_paypal', :as => :specify_paypal_info_for
      put 'verify_paypal',  :as => :verify_paypal_info_for

      # handle un-linking a verified PayPal account
      get 'pre_unlink_paypal', :as => :pre_unlink_paypal_info_for
      put 'unlink_paypal',     :as => :unlink_paypal_info_for
    end
  end

  resources :clubs, :only => [ :show, :update ] do
    member do
      # membership subscriptions
      match '/subscribe'  => 'clubs_users#new',    :as => 'subscribe_to'
      match '/add_member' => 'clubs_users#create', :as => 'add_member_to'
    end

    # mercury editor
    resource  :sales_page, :only => [ :show, :update ]

    resources :courses, :only => [ :create ] do
      collection do
        get 'show_all'
      end
    end

    resources :blogs, :only => [ :create ] do
      collection do
        get 'show_all'
      end
    end
  end

  resources :clubs_users, :only => [ :destroy ]

  resources :courses, :only => [ :show, :update ] do
    resources :lessons, :only => [ :create, :update ]
  end

  resources :blogs, :only => [ :show, :update ]

  resources :discussion_boards, :only => [ :show, :update ] do
    resources :topics, :only => [ :new, :create ]
  end

  resources :topics, :only => [ :show ] do
    resources :posts, :only => [ :new, :create ]
  end
end
