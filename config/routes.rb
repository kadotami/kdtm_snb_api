Rails.application.routes.draw do
  post 'signin' => 'user_token#create'
  resources :todos
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
