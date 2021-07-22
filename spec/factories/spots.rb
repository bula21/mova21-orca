# frozen_string_literal: true

FactoryBot.define do
  factory :spot do
    sequence(:name) { |n| "Platz #{n}" }
    color { Faker::Color.hex_color  }
    fields { build_list(:field, 3) }
  end
end
