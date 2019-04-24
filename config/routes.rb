Rails.application.routes.draw do
  resources :storeflavors
  resources :flavors
  resources :shiftjobs
  resources :jobs
  resources :shifts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :employees
  resources :stores
  resources :assignments
  resources :demos, only: [:new, :create, :destroy]
  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'demos/new', to: 'demos#new', as: :login
  get 'demos/destroy', to: 'demos#destroy', as: :logout
  
  # Set the root url
  root :to => 'home#home'  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
