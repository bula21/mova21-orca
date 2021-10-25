# frozen_string_literal: true

class UnitBlueprint < Blueprinter::Base
  identifier :id
  association :unit_activities, blueprint: UnitActivityBlueprint

  fields :language, :stufe, :week, :starts_at, :ends_at, :participant_role_counts, :district
end
