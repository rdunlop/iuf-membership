# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                   :bigint           not null, primary key
#  alternate_first_name :string
#  alternate_last_name  :string
#  birthdate            :date
#  contact_email        :string
#  first_name           :string
#  last_name            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  iuf_id               :integer
#  user_id              :bigint           not null
#
# Indexes
#
#  index_members_on_iuf_id   (iuf_id) UNIQUE
#  index_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }

  context 'validations' do
    subject { build(:member) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birthdate) }
  end

  describe 'active?' do
    context 'without a payment' do
      it 'is not active' do
        expect(member).not_to be_active
      end

      context 'creating a 2nd member of the same name' do
        it 'is valid' do
          new_member = build(:member,
                             first_name: member.first_name,
                             last_name: member.last_name,
                             birthdate: member.birthdate)
          expect(new_member).to be_valid
        end
      end
    end

    context 'with a payment' do
      let!(:payment) { create(:payment, member: member) }

      it 'is active' do
        expect(member).to be_active
      end

      context 'creating a 2nd member of the same name' do
        it 'is invalid' do
          new_member = build(:member,
                             first_name: member.first_name,
                             last_name: member.last_name,
                             birthdate: member.birthdate)
          expect(new_member).to be_invalid
        end
      end
    end
  end
end