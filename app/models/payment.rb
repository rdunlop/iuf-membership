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

# Each received payment is tracked here
class Payment < ApplicationRecord
  belongs_to :member

  scope :received, -> { where.not(received_at: nil) }

  def recent?
    received_at > 2.days.ago
  end
end
