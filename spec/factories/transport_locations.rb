# frozen_string_literal: true

FactoryBot.define do
  factory :transport_location do
    name { Faker::Lorem.words(number: 3) }
    max_participants { (100..200).to_a.sample }
  end
end
