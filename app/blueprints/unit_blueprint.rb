# frozen_string_literal: true

class UnitBlueprint < Blueprinter::Base
  identifier :id

  fields :language, :stufe, :week, :starts_at, :ends_at, :participant_role_counts, :district

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

  field :week_nr do |unit|
    # since this was hardcoded
    case unit.week
    when /Erste|Première|Prima/
      1
    when /Zweite|Deuxième|Seconda/
      2
    end
  end

  field :district_nr do |unit|
    unit.district&.scan(/\d*/)&.join('')&.to_i
  end
end
