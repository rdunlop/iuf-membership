# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    user
    sequence(:first_name) { |n| "Name #{n}" }
    sequence(:last_name) { |n| "Name #{n}" }
    birthdate { 20.years.ago }
    sequence(:contact_email) { |n| "somefake#{n}@example.com" }
  end
end
