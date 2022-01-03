# frozen_string_literal: true

class UnitActivityExecutionBlueprint < Blueprinter::Base
  identifier :id

  fields :unit_id, :activity_execution_id, :headcount
  field :activity_id do |unit_activity_execution|
    unit_activity_execution.activity&.id
  end
  # association :activity, blueprint: ActivityBlueprint
end
