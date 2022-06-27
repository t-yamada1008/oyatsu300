Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root                      'user_sessions#new'
  post    'login',          to: 'user_sessions#create'
  delete  'logout',         to: 'user_sessions#destroy'
  get     '/choose_oyatsu', to: 'oyatsus#index'

  resource :my_page, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]


  resources :users, only: %i[index new create] do
    resources :baskets, only: %i[index show new create destroy], shallow: true
  end

  namespace :admin do
    root              to: 'dashboards#index'
    get     'login',  to: 'user_sessions#new'
    post    'login',  to: 'user_sessions#create'
    delete  'logout', to: 'user_sessions#destroy'
  end
end
