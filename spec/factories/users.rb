# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "fake#{n}@example.com" }
    password { 'password' }
    confirmed_at { Time.current }
  end
end
