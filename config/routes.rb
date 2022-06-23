Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  root 'user_sessions#new'

  get     'login',  to: 'user_sessions#new'
  post    'login',  to: 'user_sessions#create'
  delete  'logout', to: 'user_sessions#destroy'

  get '/choose_oyatsu', to: 'oyatsus#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[index new create] do
    resources :baskets, only: %i[index show new create destroy], shallow: true
  end
  resource :my_page, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]

  namespace :admin do
    get 'boards/index'
    get     'login',  to: 'user_sessions#new'
    post    'login',  to: 'user_sessions#create'
    delete  'logout', to: 'user_sessions#destroy'

    resources :boards, shallow: true

  end
end
