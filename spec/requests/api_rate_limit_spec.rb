# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API member_status rate limiting', type: :request do
  let(:params) do
    { first_name: 'Nobody', last_name: 'Here', birthdate: '1900-01-01', eventdate: '2026-11-16' }
  end

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

  it 'throttles a client that exceeds the per-minute limit' do
    10.times do
      post '/api/member_status', params: params, headers: { 'REMOTE_ADDR' => '203.0.113.7' }
      expect(response).to have_http_status(:ok)
    end

    post '/api/member_status', params: params, headers: { 'REMOTE_ADDR' => '203.0.113.7' }
    expect(response).to have_http_status(:too_many_requests)
  end

  describe 'per-name limit' do
    def lookup(name_params, ip:)
      post '/api/member_status',
           params: { birthdate: '1900-01-01', eventdate: '2026-11-16' }.merge(name_params),
           headers: { 'REMOTE_ADDR' => ip }
    end

    it 'blocks the 21st lookup for one name, even from a different IP each time' do
      20.times do |i|
        lookup({ first_name: 'Robin', last_name: 'Dunlop' }, ip: "198.51.100.#{i + 1}")
        expect(response).to have_http_status(:ok)
      end

      lookup({ first_name: 'Robin', last_name: 'Dunlop' }, ip: '198.51.100.100')
      expect(response).to have_http_status(:too_many_requests)
    end

    it 'counts case and accent variants of the same name together' do
      variants = [
        { first_name: 'robin', last_name: 'dunlop' },
        { first_name: 'ROBIN', last_name: 'DUNLOP' },
        { first_name: 'Róbin', last_name: 'Dúnlop' },
        { first_name: ' Robin ', last_name: 'Dunlop ' }
      ]
      20.times do |i|
        lookup(variants[i % variants.size], ip: "198.51.100.#{i + 1}")
      end

      lookup({ first_name: 'Robin', last_name: 'Dunlop' }, ip: '198.51.100.100')
      expect(response).to have_http_status(:too_many_requests)
    end

    it 'does not limit a different name' do
      20.times do |i|
        lookup({ first_name: 'Robin', last_name: 'Dunlop' }, ip: "198.51.100.#{i + 1}")
      end

      lookup({ first_name: 'Alex', last_name: 'Smith' }, ip: '198.51.100.100')
      expect(response).to have_http_status(:ok)
    end
  end

  it 'does not throttle a different client' do
    11.times { post '/api/member_status', params: params, headers: { 'REMOTE_ADDR' => '203.0.113.7' } }

    post '/api/member_status', params: params, headers: { 'REMOTE_ADDR' => '203.0.113.8' }
    expect(response).to have_http_status(:ok)
  end
end
