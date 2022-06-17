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

  field :week_nr, &:week_nr

  field :district_nr, &:district_nr
end
