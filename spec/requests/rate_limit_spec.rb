# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rate limiting', type: :request do
  around do |example|
    original_enabled = Rack::Attack.enabled
    original_store = Rack::Attack.cache.store
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    example.run
  ensure
    Rack::Attack.enabled = original_enabled
    Rack::Attack.cache.store = original_store
  end

  def ip(number)
    { 'REMOTE_ADDR' => "192.0.2.#{number}" }
  end

  describe 'password reset' do
    it 'limits requests from one IP' do
      5.times do |i|
        post '/users/password', params: { user: { email: "user#{i}@example.com" } }, headers: ip(1)
      end

      post '/users/password', params: { user: { email: 'other@example.com' } }, headers: ip(1)
      expect(response).to have_http_status(:too_many_requests)
    end

    it 'limits requests for one email address, even from different IPs' do
      5.times do |i|
        post '/users/password', params: { user: { email: 'Target@Example.com ' } }, headers: ip(i + 10)
      end

      post '/users/password', params: { user: { email: 'target@example.com' } }, headers: ip(50)
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'registration' do
    it 'limits sign-up attempts from one IP' do
      5.times do |i|
        post '/users', params: { user: { email: "new#{i}@example.com", password: 'password123' } }, headers: ip(2)
      end

      post '/users', params: { user: { email: 'new9@example.com', password: 'password123' } }, headers: ip(2)
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'PayPal capture' do
    it 'limits requests from one IP' do
      10.times do
        post '/create-paypal-transaction', params: { orderID: 'x', memberID: 1 }, headers: ip(3)
      end

      post '/create-paypal-transaction', params: { orderID: 'x', memberID: 1 }, headers: ip(3)
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe 'general per-IP limit' do
    it 'limits a client making many requests to ordinary pages' do
      300.times { get '/privacy-policy', headers: ip(4) }

      get '/privacy-policy', headers: ip(4)
      expect(response).to have_http_status(:too_many_requests)
    end

    it 'does not count asset requests' do
      300.times { get '/assets/does-not-exist.css', headers: ip(5) }

      get '/privacy-policy', headers: ip(5)
      expect(response).not_to have_http_status(:too_many_requests)
    end
  end
end
