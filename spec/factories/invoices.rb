# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    unit
    ref { Faker::Bank.iban }
    issued_at { 1.week.ago }
    payable_until { 3.months.from_now }
    text { Faker::Lorem.sentences }
  end
end
