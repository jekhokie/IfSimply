Ifsimply::Application.routes.draw do
  root :to => 'home#index'

  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :registrations => 'registrations',
                                       :sessions      => 'sessions',
                                       :confirmations => 'confirmations',
                                       :unlocks       => 'unlocks',
                                       :passwords     => 'passwords' }

  # required for activeadmin since it always does a :get for
  # a user sign_out path
  devise_scope :user do get '/users/sign_out' => 'devise/sessions#destroy' end

  namespace :mercury do
    resources :images
  end

  scope '/mercury' do
    get ':type/:resource'        => "mercury#resource"
    get 'snippets/:name/options' => "mercury#snippet_options"
    get 'snippets/:name/preview' => "mercury#snippet_preview"
  end

  scope '/' do
    match '/registration_notify'  => 'home#registration_notify',  :as => :registration_notify
    match '/access_violation'     => 'home#access_violation',     :as => :access_violation
    match '/terms_and_conditions' => 'home#terms_and_conditions', :as => :terms_and_conditions
    match '/privacy_policy'       => 'home#privacy_policy',       :as => :privacy_policy
    match '/dmca_policy'          => 'home#dmca_policy',          :as => :dmca_policy
    match '/after_devise'         => 'home#after_devise',         :as => :after_devise
    match '/faq'                  => 'home#faq',                  :as => :faq
    match '/free_ebook'           => 'home#free_ebook',           :as => :free_ebook
    match '/download_ebook'       => 'home#download_ebook',       :as => :download_ebook
  end

  # paypal-related routing
  scope '/adaptive_payments' do
    match '/preapproval' => 'paypal_transactions#preapproval', :as => :paypal_preapproval
  end

  # mercury editor routes
  get '/editor/articles/:id'               => "articles#edit",          :as => :article_editor
  get '/editor/clubs/:id'                  => "clubs#edit",             :as => :club_editor
  get '/editor/clubs/:club_id/sales_page'  => "sales_pages#edit",       :as => :sales_page_editor
  get '/editor/clubs/:club_id/upsell_page' => "upsell_pages#edit",      :as => :upsell_page_editor
  get '/editor/courses/:id'                => "courses#edit",           :as => :course_editor
  get '/editor/discussion_boards/:id'      => "discussion_boards#edit", :as => :discussion_board_editor
  get '/editor/users/:id'                  => "users#edit",             :as => :user_editor

  resources :users, :only => [ :show, :update ] do
    member do
      # handle PayPal verification
      get 'specify_paypal', :as => :specify_paypal_info_for
      put 'verify_paypal',  :as => :verify_paypal_info_for
    end
  end

  resources :clubs, :only => [ :show, :update ] do
    member do
      # membership subscriptions
      match '/subscribe'          => 'clubs_users#new',          :as => 'subscribe_to'
      match '/add_member'         => 'clubs_users#create',       :as => 'add_member_to'
      match '/admin'              => 'admin#show',               :as => 'admin_page_for'
      match '/specify_price'      => 'clubs#specify_price',      :as => 'specify_price_for'
      match '/update_price'       => 'clubs#update_price',       :as => 'update_price_for'
      match '/subscribers'        => 'clubs#subscribers',        :as => 'subscribers_to'
      match '/export_subscribers' => 'clubs#export_subscribers', :as => 'export_subscribers_for'

      put 'update_free_content'
    end

    # mercury editor
    resource :sales_page,  :only => [ :show, :update ]
    resource :upsell_page, :only => [ :show, :update ]

    resources :courses, :only => [ :create ] do
      collection do
        get 'show_all'
      end
    end

    resources :articles, :only => [ :create ] do
      collection do
        get 'show_all'
      end
    end
  end

  resources :clubs_users, :only => [ :destroy ]

  resources :courses, :only => [ :show, :update, :destroy ] do
    collection do
      post 'sort'
    end

    resources :lessons, :only => [ :create, :update ] do
      put 'update_file_attachment'
    end
  end

  resources :lessons, :only => [ :destroy ]

  resources :articles, :only => [ :show, :update, :destroy ]

  resources :discussion_boards, :only => [ :show, :update ] do
    resources :topics, :only => [ :new, :create ]
  end

  resources :topics, :only => [ :show ] do
    resources :posts, :only => [ :new, :create ]
  end
end
