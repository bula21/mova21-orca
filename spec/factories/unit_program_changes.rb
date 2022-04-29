# frozen_string_literal: true

FactoryBot.define do
  factory :unit_program_change do
    unit { nil }
    unit_activity_execution
    notified_at { nil }
    remarks { 'MyText' }
  end
end
