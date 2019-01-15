Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'authentication#authenticate'
      post 'auth/forgetpassword', to: 'authentication#send_reset_token'
      post 'auth/resetpassword', to: 'authentication#reset_password'
      post 'signup', to: 'users#create'
      get 'users/me', to: 'users#show'
      put 'users/:id', to: 'users#update'
      post 'users/changepassword', to: 'users#change_password'

      resources :records, except: [:create, :new, :edit] do
        collection do
          post :start, to: 'records#start'
          post :end, to: 'records#end'
        end
      end
      resources :monthly_reports, only: [:index, :show]
    end
  end
end
