Rails.application.routes.draw do
  # Admin
  get 'admin', to: 'admin#index'

  # Auth
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Transaction
  post '/transactions', to: 'transactions#create'
end
