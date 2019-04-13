Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :employees
  resources :stores
  resources :assignments
  root 'employees#index'
end
