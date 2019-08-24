# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }

  describe 'active?' do
    context 'without a payment' do
      it 'is not active' do
        expect(member).not_to be_active
      end
    end

    context 'with a payment' do
      let!(:payment) { create(:payment, member: member) }

      it 'is active' do
        expect(member).to be_active
      end
    end
  end
end
