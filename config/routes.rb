# frozen_string_literal: true

Rails.application.routes.draw do
  resources :members
  devise_for :users
  root to: 'home#index'

  post '/paypal-transaction-complete', as: :paypal_confirmation, to: 'paypal#confirm'

  post '/api/member_status', to: 'api/members#status'
end
