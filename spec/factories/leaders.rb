# frozen_string_literal: true

# == Schema Information
#
# Table name: leaders
#
#  id           :bigint           not null, primary key
#  address      :string
#  birthdate    :date
#  country      :string
#  email        :string
#  first_name   :string
#  gender       :string
#  language     :string
#  last_name    :string
#  phone_number :string
#  scout_name   :string
#  town         :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pbs_id       :integer
#
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
    address { Faker::Address.street_name }
    zip_code { Faker::Address.zip_code }
    town { Faker::Address.city }
    # trait :al do
    # end
  end
end
