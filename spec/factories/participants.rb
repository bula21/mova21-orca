# frozen_string_literal: true

FactoryBot.define do
  factory :participant do
    sequence(:pbs_id) { |n| n }
    last_name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    scout_name { Faker::Superhero.name }
    birthdate { Faker::Date.birthday(min_age: 5, max_age: 35) }
    gender { Participant.genders.keys.sample }
  end
end
