# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  order_id     :string
#  received_at  :datetime
#  amount_cents :integer
#  currency     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  start_date   :datetime
#
# Indexes
#
#  index_payments_on_member_id  (member_id)
#

FactoryBot.define do
  factory :payment do
    member
    sequence(:order_id) { |n| "ORD#ABC#{n}" }
    currency { 'EUR' }
    amount_cents { 1500 }
    received_at { 1.minute.ago }
  end
end
