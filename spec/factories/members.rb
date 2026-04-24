# frozen_string_literal: true
# == Schema Information
#
# Table name: members
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  first_name           :string
#  alternate_first_name :string
#  last_name            :string
#  alternate_last_name  :string
#  birthdate            :date
#  contact_email        :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  iuf_id               :integer
#
# Indexes
#
#  index_members_on_iuf_id   (iuf_id) UNIQUE
#  index_members_on_user_id  (user_id)
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
