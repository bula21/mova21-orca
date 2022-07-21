# frozen_string_literal: true

class UnitBlueprint < Blueprinter::Base
  identifier :id

  fields :language, :stufe, :week, :starts_at, :ends_at, :participant_role_counts, :district, :abteilung

  field :expected_participant_counts do |unit|
    {
      participant: unit.expected_participants,
      leader: unit.expected_participants_leitung
    }
  end

  view :with_unit_activities do
    association :unit_activities, blueprint: UnitActivityBlueprint
    association :unit_activity_executions, blueprint: UnitActivityExecutionBlueprint
  end

  # rubocop:disable Style/SymbolProc
  field :week_nr do |unit|
    unit.week_nr
  end

  field :district_nr do |unit|
    unit.district_nr
  end
  # rubocop:enable Style/SymbolProc
end
