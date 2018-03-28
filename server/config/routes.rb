# config/routes.rb
Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :projects do
        resources :scans do
          resources :dependencies do
            get 'latest', to: 'latest#show'
          end
          post '/updates/:id', to: 'updates#create'
          resources :reports
        end
        resources :upload
      end
      resources :cve
      resources :exploit
      post 'auth/login', to: 'authentication#authenticate'
      post 'signup', to: 'users#create'
      post 'login', to: 'users#login'
      post 'upload', to: 'upload#create'
      get 'profile', to: 'profile#profile_get'
    end
  end
  apipie
  root to: 'welcome#show'
end
