Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'authentication#authenticate'
      post 'signup', to: 'users#create'
      get 'users/me', to: 'users#show'
    end
  end
end
