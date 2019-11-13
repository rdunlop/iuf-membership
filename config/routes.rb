# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :members
    resources :payments

    root to: 'users#index'
  end

  resources :members
  devise_for :users
  root to: 'home#index'
  get '/privacy-policy', to: 'home#privacy_policy'

  post '/create-paypal-transaction', as: :paypal_transaction, to: 'paypal#create'

  post '/api/member_status', to: 'api/members#status'
end
