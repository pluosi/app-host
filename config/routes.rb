Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :apps do 
    resources :plats
  end

  resources :users

  resources :plats do
    resources :pkgs
  end

  resources :pkgs, only:[:show] do
    member do 
      get :manifest
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  
  # , only:[:index,:show,:create,:new]

  root "apps#index"
end
