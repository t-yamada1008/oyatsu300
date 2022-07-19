Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root                      'user_sessions#new'
  post    'login',          to: 'user_sessions#create'
  delete  'logout',         to: 'user_sessions#destroy'
  get     '/choose_oyatsu', to: 'oyatsus#index'

  resource :users, only: %i[new create] do
    resources :ensokus, shallow: true  do
      resources :baskets, only: %i[create destroy], shallow: true
    end
  end

  resource :my_page, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  resources :everyone_oyatsus, only: %i[index show]

  namespace :admin do
    root              to: 'dashboards#index'
    get     'login',  to: 'user_sessions#new'
    post    'login',  to: 'user_sessions#create'
    delete  'logout', to: 'user_sessions#destroy'
  end
end
