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

require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { create(:payment) }

  context '#recent?' do
    context 'when recently received' do
      subject { build(:payment, received_at: 1.day.ago) }
      it { should be_recent }
    end

    context 'when received a week ago' do
      subject { build(:payment, received_at: 1.week.ago) }
      it { should_not be_recent }
    end
  end
end
