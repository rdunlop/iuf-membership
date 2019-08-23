# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Specs', type: :request do
  let(:params) { { first_name: 'Bob', last_name: 'Smith', birthdate: '22-12-2000' } }

  def do_action(params)
    headers = {
      'ACCEPT' => 'application/json'
    }
    post '/api/member_status', params: params, session: headers
  end

  context 'when the user exists in the db' do
    xit 'responds with a success' do
      do_action(params)
      expect(response.body).to eq("{ found: 'true'}")
    end
  end

  context 'when the user does not exist' do
    xit 'gives back a no-data response' do
      do_action(params)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq('{}')
    end
  end
end
