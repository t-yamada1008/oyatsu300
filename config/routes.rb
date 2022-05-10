Rails.application.routes.draw do
  root 'oyatsus#index'
  get 'users/index'
  get 'users/show'
  get 'baskets/index'
  get 'oyatsus/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
