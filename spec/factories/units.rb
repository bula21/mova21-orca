# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    sequence(:pbs_id) { |n| n }
    title { Faker::Movies::StarWars.planet }
    abteilung { Faker::Company.name }
    kv { Unit::KVS.sample }
    stufe { Unit.stufen.keys.sample }
    expected_participants_f { (10..20).to_a.sample }
    expected_participants_m { (10..20).to_a.sample }
    expected_participants_leitung_f { (2..10).to_a.sample }
    expected_participants_leitung_m { (2..10).to_a.sample }
    starts_at { Faker::Date.in_date_period(year: 2022, month: 7) }
    ends_at { Faker::Date.in_date_period(year: 2022, month: 8) }
    association :al, factory: :leader
    association :lagerleiter, factory: :leader
  end
end
