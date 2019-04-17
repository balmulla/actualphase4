Rails.application.routes.draw do
  resources :shifts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :employees
  resources :stores
  resources :assignments
  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  
  # Set the root url
  root :to => 'home#home'  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
