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
      get :useage
      put :api_token, to: "users#refresh_api_token"
    end
  end

  resources :plats do
    resources :pkgs
    member do
      get :latest
    end
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
  
  resource :api, only:[] do
    post "pkgs" => "pkgs#api_create"
    put "plat/sort" => "plats#api_sort"
    get "plats/:plat_id/latest" => "plats#api_latest"

    get "pkgs/:pkg_id" => "pkgs#api_show"
  end
  
  root "apps#index"

end
