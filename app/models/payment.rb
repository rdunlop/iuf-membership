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
#  start_date   :datetime
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

  after_commit :set_start_date, on: :create

  # is this payment still covering the user's membership
  def active?(as_of_date = DateTime.current)
    start_date.to_date <= as_of_date && expiration_date.to_date >= as_of_date
  end

  def recent?
    received_at > 2.days.ago
  end

  def expiration_date
    if start_date < Date.new(2021)
      # Because of Covid19, the Unicon was delayed 2 years
      # We extend their payment validity to the end of Unicon in 2022
      Date.new(2022, 8, 6) # Final day of Unicon 2022
    else
      start_date + 2.years
    end
  end

  private

  # Set the start date if not already set
  def set_start_date
    update_column(:start_date, created_at) if start_date.nil? # rubocop:disable Rails/SkipsModelValidations
  end
end
