# frozen_string_literal: true

FactoryBot.define do
  factory :rover_shift do
    starts_at { '2022-07-19 18:51:15' }
    ends_at { '2022-07-19 18:51:15' }
    place { 'MyString' }
    job_id { 1 }
  end
end
