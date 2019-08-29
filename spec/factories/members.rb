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

FactoryBot.define do
  factory :member do
    user
    sequence(:first_name) { |n| "Name #{n}" }
    sequence(:last_name) { |n| "Name #{n}" }
    birthdate { 20.years.ago }
    sequence(:contact_email) { |n| "somefake#{n}@example.com" }
  end
end
