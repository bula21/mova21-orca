# frozen_string_literal: true

FactoryBot.define do
  factory :leader do
    sequence(:pbs_id) { |n| n }
    last_name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    scout_name { Faker::Superhero.name }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 35) }
    gender { Leader.genders.keys.sample }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    language { Leader.languages.keys.sample }

    trait :al do
    end
  end
end
