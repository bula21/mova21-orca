# frozen_string_literal: true

FactoryBot.define do
  factory :activity_execution do
    activity
    starts_at { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    amount_participants { Faker::Number.between(from: 12, to: activity&.participants_count_activity || 30) }
    transport { true }
    mixed_languages { true }
    transport_ids { '' }
    language_flags { activity.language_flags }
    add_attribute(:field) { create(:field) }
    ends_at { starts_at + (1..14).to_a.sample.hours }
  end
end
