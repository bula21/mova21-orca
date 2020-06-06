# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    label { Faker::Lorem.words(number: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    language { Activity.languages.keys.sample }
    block_type { Activity.block_types.keys.sample }
    simo { Activity.simos.keys.sample }
    participants_count_activity { (10..20).to_a.sample }
    participants_count_transport { (10..20).to_a.sample }
    duration_activity { (0..60).to_a.sample }
    duration_journey { (0..60).to_a.sample }
    location { Faker::Address.city }
  end
end
