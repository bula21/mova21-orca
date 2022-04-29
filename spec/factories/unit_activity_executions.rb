# frozen_string_literal: true

FactoryBot.define do
  factory :unit_activity_execution do
    unit
    activity_execution
    headcount { nil }
    track_changes_enabled { false }
  end
end
