# frozen_string_literal: true

class UnitBlueprint < Blueprinter::Base
  identifier :id

  fields :language, :stufe, :week, :starts_at, :ends_at, :participant_role_counts, :district

  view :with_unit_activities do
    association :unit_activities, blueprint: UnitActivityBlueprint
    association :unit_activity_executions, blueprint: UnitActivityExecutionsBlueprint
  end
end
