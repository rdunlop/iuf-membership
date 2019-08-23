# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    member
    sequence(:order_id) { |n| "ORD#ABC#{n}" }
    currency { 'EUR' }
    amount_cents { 1500 }
    received_at { 1.minute.ago }
  end
end
