Rails.application.routes.draw do
  root 'users#index'
  resources :users

  get 'posts/new', to: 'posts#new', as: :post_new
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
