# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaypalConfirmer, type: :model do
  let(:incoming_message) do
    {
      status_code: 200,
      result: {
        id: 'ABC123',
        purchase_units: [
          {
            custom_id: member.id,
            amount: {
              value: '15.00',
              currency_code: 'EUR'
            }
          }
        ],
        create_time: '2019-08-23T03:02:24Z'
      }
    }
  end

  context 'when a matching member exists' do
    let!(:member) { create(:member) }

    it 'creates a payment' do
      described_class.new.create_payment(incoming_message[:result])
      expect(Payment.count).to eq(1)
    end

    context 'when the member already has an OLD payment' do
      let!(:payment) { create(:payment, member: member, start_date: 3.years.ago) }

      it 'creates a payment with start_date = created_at' do
        described_class.new.create_payment(incoming_message[:result])
        expect(Payment.last.start_date).to eq(Payment.last.created_at)
      end
    end

    context 'when the member has an ACTIVE payment' do
      let!(:payment) { create(:payment, member: member, start_date: 1.day.ago) }

      it 'creates a payment with start_date = expiration_date' do
        described_class.new.create_payment(incoming_message[:result])
        expect(Payment.last.start_date.to_date).to eq(payment.expiration_date.to_date)
      end
    end
  end
end
