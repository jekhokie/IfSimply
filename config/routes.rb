Ifsimply::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations' }

  root :to => 'home#index'

  scope '/' do
    match '/learn_more'          => 'home#learn_more',          :as => :learn_more
    match '/registration_notify' => 'home#registration_notify', :as => :registration_notify
  end

  resources :clubs, :only => [ :edit ]
end
