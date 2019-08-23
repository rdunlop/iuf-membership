# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaypalConfirmer, type: :model do
  let(:incoming_message) do
    {
      status_code: 200,
      result: {
        custom_id: member.id,
        id: 'ABC123',
        amount: {
          value: '15.00',
          currency_code: 'EUR'
        },
        create_time: '123'
      }
    }
  end

  context 'when a matching member exists' do
    let!(:member) { create(:member) }

    it 'creates a payment' do
      described_class.new.create_payment(incoming_message)
      expect(Payment.count).to eq(1)
    end
  end
end
