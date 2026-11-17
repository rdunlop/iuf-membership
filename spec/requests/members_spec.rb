# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:member) { create(:member, user: user) }

  describe 'DELETE /members/:id' do
    context 'when the owner signs in and the member has no payments' do
      before { sign_in(user) }

      it 'deletes the member without raising an error' do
        expect { delete member_path(member) }.to change(Member, :count).by(-1)

        expect(response).to redirect_to(members_path)
        expect(flash[:notice]).to eq('Member deleted')
      end
    end

    context 'when a different user signs in' do
      let(:other_user) { create(:user) }

      before { sign_in(other_user) }

      it 'does not delete the member' do
        expect { delete member_path(member) }.not_to change(Member, :count)

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end

    context 'when the owner signs in but the member has a payment' do
      before do
        sign_in(user)
        create(:payment, member: member)
      end

      it 'does not delete the member' do
        expect { delete member_path(member) }.not_to change(Member, :count)

        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end
end
