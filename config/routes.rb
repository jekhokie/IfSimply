Ifsimply::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => 'home#index'

  scope '/' do
    match '/learn_more'          => 'home#learn_more',          :as => :learn_more
    match '/registration_notify' => 'home#registration_notify', :as => :registration_notify
    match '/access_violation'    => 'home#access_violation',    :as => :access_violation
  end

  resources :clubs, :only => [ :edit, :update ] do
    member do
      # handle image updates
      match '/change_logo' => 'clubs#change_logo', :as => :change_logo_for
      match '/upload_logo' => 'clubs#upload_logo', :as => :upload_logo_for
    end

    resources :courses, :only => [ :create ]
    resources :blogs,   :only => [ :create ] do
      collection do
        get 'show_all'
      end
    end
  end

  resources :courses, :only => [ :edit, :update ] do
    resources :lessons, :only => [ :create, :update ]
  end

  resources :blogs, :only => [ :edit, :update ] do
    member do
      # handle image updates
      match '/change_image' => 'blogs#change_image', :as => :change_image_for
      match '/upload_image' => 'blogs#upload_image', :as => :upload_image_for
    end
  end

  resources :discussion_boards, :only => [ :edit, :update ] do
    resources :topics, :only => [ :new, :create ]
  end

  resources :topics, :only => [ :show ] do
    resources :posts, :only => [ :new, :create ]
  end
end
