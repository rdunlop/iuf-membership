# frozen_string_literal: true

require 'rails_helper'
require 'paypal_server_sdk'

RSpec.describe PaypalConfirmer, type: :model do
  let(:fake_order) do
    PaypalServerSdk::Order.from_hash(
      { 'id' => '0AL45934301345841',
        'status' => 'COMPLETED',
        'payment_source' =>
        { 'paypal' =>
          { 'email_address' => 'robin@dunlopweb.com', 'account_id' => 'MRZ2H2XHNMAC8', 'account_status' => 'UNVERIFIED',
            'name' => { 'given_name' => 'rbin', 'surname' => 'dunlop' }, 'address' => { 'country_code' => 'US' } } },
        'purchase_units' =>
        [{ 'reference_id' => 'default',
           'payments' =>
           { 'captures' =>
             [{ 'id' => '5RK42426ND6227427',
                'status' => 'PENDING',
                'status_details' => { 'reason' => 'RECEIVING_PREFERENCE_MANDATES_MANUAL_ACTION' },
                'amount' => { 'currency_code' => 'EUR', 'value' => '15.00' },
                'final_capture' => true,
                'seller_protection' => { 'status' => 'ELIGIBLE', 'dispute_categories' => %w[ITEM_NOT_RECEIVED UNAUTHORIZED_TRANSACTION] },
                'custom_id' => member.id,
                'links' =>
                [{ 'href' => 'https://api.sandbox.paypal.com/v2/payments/captures/5RK42426ND6227427', 'rel' => 'self', 'method' => 'GET' },
                 { 'href' => 'https://api.sandbox.paypal.com/v2/payments/captures/5RK42426ND6227427/refund', 'rel' => 'refund', 'method' => 'POST' },
                 { 'href' => 'https://api.sandbox.paypal.com/v2/checkout/orders/0AL45934301345841', 'rel' => 'up', 'method' => 'GET' }],
                'create_time' => '2025-01-07T17:06:04Z',
                'update_time' => '2025-01-07T17:06:04Z' }] } }],
        'payer' => { 'name' => { 'given_name' => 'rbin', 'surname' => 'dunlop' }, 'email_address' => 'robin@dunlopweb.com', 'payer_id' => 'MRZ2H2XHNMAC8',
                     'address' => { 'country_code' => 'US' } },
        'links' => [{ 'href' => 'https://api.sandbox.paypal.com/v2/checkout/orders/0AL45934301345841', 'rel' => 'self', 'method' => 'GET' }] }
    )
  end

  context 'when a matching member exists' do
    let!(:member) { create(:member) }

    it 'creates a payment' do
      described_class.new.create_payment(fake_order)
      expect(Payment.count).to eq(1)
    end

    context 'when the member already has an OLD payment' do
      let!(:payment) { create(:payment, member: member, start_date: 3.years.ago) }

      it 'creates a payment with start_date = created_at' do
        described_class.new.create_payment(fake_order)
        expect(Payment.last.start_date).to eq(Payment.last.created_at)
      end
    end

    context 'when the member has an ACTIVE payment' do
      let!(:payment) { create(:payment, member: member, start_date: 1.day.ago) }

      it 'creates a payment with start_date = expiration_date' do
        described_class.new.create_payment(fake_order)
        expect(Payment.last.start_date.to_date).to eq(payment.expiration_date.to_date)
      end
    end
  end
end
