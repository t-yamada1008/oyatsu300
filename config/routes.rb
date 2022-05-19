Rails.application.routes.draw do
  root 'users#new'
  get '/choose_oyatsu', to: 'oyatsus#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[index new create edit update] do
    resources :baskets, only: %i[index show new create destroy], shallow: true
  end
end
