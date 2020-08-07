Rails.application.routes.draw do
  root      'posts#index'
  resources :posts
  get       'posts_with_password/:id', to: 'posts#posts_with_password'
  post      'posts_with_password/:id', to: 'posts#authenticate'
end
