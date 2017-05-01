PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  resources :posts, except: :destroy
  resources :categories, only: [:show, :create, :new]
end
