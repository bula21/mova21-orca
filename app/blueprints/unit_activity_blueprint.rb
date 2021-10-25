# frozen_string_literal: true

class UnitActivityBlueprint < Blueprinter::Base
  identifier :id

  association :activity, blueprint: ActivityBlueprint
  # association :unit, blueprint: UnitBlueprint
  fields :unit_id, :activity_id

  # rubocop:disable Style/SymbolProc
  field :priority do |unit_activity|
    unit_activity.priority_rank
  end
  # rubocop:enable Style/SymbolProc
end
