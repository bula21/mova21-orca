# frozen_string_literal: true

class ActivityExecutionBlueprint < Blueprinter::Base
  extend ActivityExecutionHelper
  identifier :id

  fields :languages, :starts_at, :ends_at, :amount_participants, :transport, :mixed_languages, :spot, :transport_ids

  association :field, blueprint: FieldBlueprint
  association :spot, blueprint: SpotBlueprint
  field :languages do |activity_execution|
    available_languages_for_frontend(activity_execution)
  end
end
