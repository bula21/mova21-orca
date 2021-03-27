# frozen_string_literal: true

FactoryBot.define do
  factory :unit_activity do
    unit
    activity
    # priority
    remarks { 'Remakrs' }
  end
end
