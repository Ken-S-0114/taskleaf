Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  namespace :admin do
    resources :users
  end

  root to: 'tasks#index'
  resources :tasks
end
