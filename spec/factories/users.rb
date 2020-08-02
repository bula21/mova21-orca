# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@bula.example" }
    pbs_id { nil }
    uid { email }
    provider { :test }
    leader { build(:leader, pbs_id: pbs_id, email: email) }

    trait :midata_user do
      sequence(:pbs_id) { |n| n }
      role_user { true }
    end

    trait :admin do
      role_admin { true }
    end
  end
end
