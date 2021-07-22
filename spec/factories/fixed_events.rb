# frozen_string_literal: true

FactoryBot.define do
  factory :fixed_event do
    title { 'Lagereröffnung' }
    starts_at { Faker::Time.between(from: 2.days.ago, to: Time.zone.today) }
    ends_at { starts_at + (1..3).to_a.sample.hours }
  end
end
