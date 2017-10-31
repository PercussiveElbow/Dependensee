# config/routes.rb
Rails.application.routes.draw do
  resources :projects do
    resources :scans do
      resources :dependencies
    end
    resources :upload
  end


  resources :cve do
  end

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  post 'login', to: 'users#login'
  post 'upload', to: 'upload#create'
end