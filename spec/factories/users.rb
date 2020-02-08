# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@bula.example" }
    uid { email }

    trait :midata do
      provider { 'midata' }
    end
  end
end
