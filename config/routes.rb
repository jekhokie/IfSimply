Ifsimply::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  scope '/' do
    match '/learn_more' => 'home#learn_more', :as => :learn_more
  end
end
