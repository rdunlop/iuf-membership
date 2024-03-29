# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Specs', type: :request do
  let(:params) { { first_name: 'Bob', last_name: 'Smith', birthdate: '2000-12-22', eventdate: '2024-07-26' } }

  def do_action(params)
    headers = {
      'ACCEPT' => 'application/json'
    }
    post '/api/member_status', params: params, headers: headers
  end

  context 'when the user exists in the db' do
    let!(:member) do
      create(:member,
             first_name: 'Bob',
             last_name: 'Smith',
             birthdate: '2000-12-22')
    end

    context 'when the user is not active' do
      it 'responds with not-member' do
        do_action(params)
        expect(response.parsed_body).to eq('member' => false)
      end
    end

    context "when the user has a payment which is active, but won't be active by event date" do
      let!(:payment) { create(:payment, member: member, created_at: Date.new(2024, 7, 26) - 2.years - 2.days) }

      before do
        member.update(iuf_id: 4)
      end

      it 'responds with not-member' do
        do_action(params)
        expect(response.parsed_body).to eq('member' => false)
      end
    end

    context 'When the user is active' do
      let!(:payment) { create(:payment, member: member, created_at: Date.new(2024, 7, 1)) }
      before do
        member.update(iuf_id: 4)
      end

      it 'responds with a success' do
        do_action(params)
        expect(response.parsed_body).to eq('member' => true, 'iuf_member_id' => 'IUF00004')
      end
    end
  end

  context 'when the user does not exist' do
    it 'gives back a not-member response' do
      do_action(params)
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body).to eq('member' => false)
    end
  end
end
