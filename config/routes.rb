Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get '/top', to: 'users#new'
  root 'oyatsus#index'
  get 'baskets/index'
  get 'oyatsus/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[new create]
end
