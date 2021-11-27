# frozen_string_literal: true

class ActivityBlueprint < Blueprinter::Base
  identifier :id

  association :activity_category, blueprint: ActivityCategoryBlueprint
  association :activity_executions, blueprint: ActivityExecutionBlueprint
  fields :label_in_database

  field :stufen do |activity|
    activity&.stufen&.map(&:code)
  end
end
