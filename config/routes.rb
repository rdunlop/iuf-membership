Rails.application.routes.draw do
  resources :members
  devise_for :users
  root to: "home#index"
end
