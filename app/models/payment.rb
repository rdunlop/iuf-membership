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

  # is this payment still covering the user's membership
  def active?(as_of_date = Date.current)
    expiration_date > as_of_date
  end

  def recent?
    received_at > 2.days.ago
  end

  def expiration_date
    if created_at < Date.new(2021)
      # Because of Covid19, the Unicon was delayed 2 years
      # We extend their payment validity to the end of Unicon in 2022
      Date.new(2022, 8, 6) # Final day of Unicon 2022
    else
      created_at + 2.years
    end
  end
end
