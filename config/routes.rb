Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'authentication#authenticate'
      post 'auth/forgetpassword', to: 'authentication#send_reset_token'
      post 'auth/resetpassword', to: 'authentication#reset_password'
      post 'signup', to: 'users#create'
      get 'users/me', to: 'users#show'
      post 'users/changepassword', to: 'users#change_password'
    end
  end
end
