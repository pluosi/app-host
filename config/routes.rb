Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :apps do 
    resources :plats
  end

  resources :users do
    member do 
      get :api_token
      put "api_token" => "users#refresh_api_token"
    end
  end

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

  post "api/pkgs" => "pkgs#api_create"
end
