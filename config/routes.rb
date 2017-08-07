Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :apps do 
    resources :plats
  end

  resources :plats do
    resources :pkgs
  end
  
  # , only:[:index,:show,:create,:new]

  root "apps#index"
end
