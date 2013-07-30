Ifsimply::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions' }

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

  resources :users, :only => [ :edit, :update ] do
    member do
      # handle image updates
      match '/change_icon' => 'users#change_icon', :as => :change_icon_for
      match '/upload_icon' => 'users#upload_icon', :as => :upload_icon_for
    end
  end

  # mercury editor routes
  get '/editor/clubs/:id'                 => "clubs#edit",             :as => :club_editor
  get '/editor/discussion_boards/:id'     => "discussion_boards#edit", :as => :discussion_board_editor
  get '/editor/clubs/:club_id/sales_page' => "sales_pages#edit",       :as => :sales_page_editor

  resources :clubs, :only => [ :show, :update ] do
    member do
      # handle image updates
      match '/change_logo' => 'clubs#change_logo', :as => :change_logo_for
      match '/upload_logo' => 'clubs#upload_logo', :as => :upload_logo_for

      # membership subscriptions
      match '/subscribe'  => 'clubs_users#new',    :as => 'subscribe_to'
      match '/add_member' => 'clubs_users#create', :as => 'add_member_to'
    end

    # mercury editor
    resource  :sales_page, :only => [ :update, :show ]

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

  resources :courses, :only => [ :show, :edit, :update ] do
    member do
      # handle image updates
      match '/change_logo' => 'courses#change_logo', :as => :change_logo_for
      match '/upload_logo' => 'courses#upload_logo', :as => :upload_logo_for
    end

    resources :lessons, :only => [ :create, :update ]
  end

  resources :blogs, :only => [ :show, :edit, :update ] do
    member do
      # handle image updates
      match '/change_image' => 'blogs#change_image', :as => :change_image_for
      match '/upload_image' => 'blogs#upload_image', :as => :upload_image_for
    end
  end

  resources :discussion_boards, :only => [ :show, :update ] do
    resources :topics, :only => [ :new, :create ]
  end

  resources :topics, :only => [ :show ] do
    resources :posts, :only => [ :new, :create ]
  end
end
