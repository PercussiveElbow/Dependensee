# config/routes.rb
Rails.application.routes.draw do
  # apipie
  scope :api do
    resources :projects do
      resources :scans do
        resources :dependencies do
          get 'latest', to: 'latest#show'
        end
      resources :reports
      end
      resources :upload
    end

    resources :cve do
    end
    resources :exploit do
    end

    post 'auth/login', to: 'authentication#authenticate'
    post 'signup', to: 'users#create'
    post 'login', to: 'users#login'
    post 'upload', to: 'upload#create'
    get 'profile', to: 'profile#profile_get'
  end

  get "/ui", to: static("index.html")

end
