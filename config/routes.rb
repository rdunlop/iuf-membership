# frozen_string_literal: true

Rails.application.routes.draw do
  resources :members
  devise_for :users
  root to: 'home#index'

  post "/paypal-transaction-complete", as: :paypal_confirmation, to: "paypal#confirm"
end
