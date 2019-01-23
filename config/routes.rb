Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :apps do 
    resources :plats
    collection do
      get :archived
    end
  end

  resources :users do
    member do 
      get :api_token
      put :api_token, to: "users#refresh_api_token"
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

  resources :udid, only:[:create,:index] do
    collection do
      get "mobileconfig"
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  
  root "apps#index"

  post "api/pkgs" => "pkgs#api_create"

  put "api/plat/sort" => "plats#api_sort"

end
