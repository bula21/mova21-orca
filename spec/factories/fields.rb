# frozen_string_literal: true

FactoryBot.define do
  factory :field do
    sequence(:name) { |n| "Feld #{n}" }
    spot { build(:spot, fields: []) }
  end
end
