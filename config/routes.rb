Rails.application.routes.draw do
  root 'posts#top'
  resources :users
  get '/login', to: 'users#login', as: :login

  get '/top', to: 'posts#top', as: :top
  get '/posts/new', to: 'posts#new', as: :new_post
  post 'posts/new', to: 'posts#create'
  get '/posts/(:id)', to: 'posts#show', as: :post
  delete '/posts/(:id)', to: 'posts#destroy'
  patch '/posts/(:id)', to: 'posts#update'
  get '/posts/(:id)/edit', to: 'posts#edit', as: :edit_post
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
