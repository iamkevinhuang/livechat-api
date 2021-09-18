Rails.application.routes.draw do
  namespace :api do
    post "/login", to: "users#login"
    get "/auto_login", to: "users#auto_login"
    
    resources :users  
    resources :rooms do 
      resources :messages
    end
  end

  

  mount ActionCable.server => '/cable'
end
