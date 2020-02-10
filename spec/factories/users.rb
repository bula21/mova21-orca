# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@bula.example" }
    uid { email }
    provider { :test }

    trait :with_pbs_id do
      sequence(:pbs_id) { |n| n }
    end
  end
end
