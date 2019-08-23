# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id           :bigint           not null, primary key
#  amount_cents :integer
#  currency     :string
#  received_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  member_id    :bigint           not null
#  order_id     :string
#
# Indexes
#
#  index_payments_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
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
