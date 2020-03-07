# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    unit
    ref { Faker::Bank.iban }
    issued_at { 1.week.ago }
    payable_until { 3.months.from_now }
    text { Faker::Lorem.sentences }
  end

  trait :with_invoice_parts do
    after(:build) do |invoice|
      invoice.invoice_parts = build_list(:invoice_part, 3, invoice: invoice)
    end
  end
end
