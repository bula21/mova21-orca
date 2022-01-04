# frozen_string_literal: true

class ActivityExecutionBlueprint < Blueprinter::Base
  extend ActivityExecutionHelper
  identifier :id

  fields :languages, :amount_participants, :transport, :mixed_languages, :spot, :transport_ids
  field :starts_at, datetime_format: ->(datetime) { datetime.nil? ? datetime : datetime.iso8601 }
  field :ends_at, datetime_format: ->(datetime) { datetime.nil? ? datetime : datetime.iso8601 }

  association :field, blueprint: FieldBlueprint
  association :spot, blueprint: SpotBlueprint
  association :unit_activity_executions, blueprint: UnitActivityExecutionBlueprint
  field :languages do |activity_execution|
    available_languages_for_frontend(activity_execution)
  end

  view :with_activity do
    association :activity, blueprint: ActivityBlueprint

    field :title do |activity_execution|
      activity_execution.activity.label
    end
  end

  view :with_fields do
    association :spot, blueprint: SpotBlueprint, view: :with_fields
  end
end
