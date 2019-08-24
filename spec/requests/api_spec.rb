# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Specs', type: :request do
  let(:params) { { first_name: 'Bob', last_name: 'Smith', birthdate: '22-12-2000' } }

  def do_action(params)
    headers = {
      'ACCEPT' => 'application/json'
    }
    post '/api/member_status', params: params, headers: headers
  end

  context 'when the user exists in the db' do
    let!(:member) { create(:member, first_name: 'Bob') }

    xit 'responds with a success' do
      do_action(params)
      expect(response.parsed_body).to eq('found' => true)
    end
  end

  context 'when the user does not exist' do
    it 'gives back a no-data response' do
      do_action(params)
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body).to eq({})
    end
  end
end
