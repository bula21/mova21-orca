# frozen_string_literal: true

class UnitActivityExecutionBlueprint < Blueprinter::Base
  identifier :id

  fields :unit_id, :activity_execution_id, :headcount
end
