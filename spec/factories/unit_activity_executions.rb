# frozen_string_literal: true

FactoryBot.define do
  factory :unit_activity_execution do
    unit
    activity_execution
    headcount { nil }
  end
end
