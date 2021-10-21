# frozen_string_literal: true

class UnitActivityBlueprint < Blueprinter::Base
  identifier :id

  association :activity, blueprint: ActivityBlueprint
  # association :unit, blueprint: UnitBlueprint
  fields :unit_id, :activity_id

  field :priority, &:priority_rank
end
