# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    label { Faker::Lorem.words(3) }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    language { Activity.languages.keys.sample }
    js_type { Activity.block_type.keys.sample }
    simo { Activity.simo.keys.sample }
    participants_count_activity { (10..20).to_a.sample }
    participants_count_transport { (10..20).to_a.sample }
    duration_activity { (0..60).to_a.sample }
    duration_journey { (0..60).to_a.sample }
    location { Faker::Address.city }
  end
end
