# frozen_string_literal: true

class ActivityBlueprint < Blueprinter::Base
  identifier :id

  association :activity_category, blueprint: ActivityCategoryBlueprint
  association :activity_executions, blueprint: ActivityExecutionBlueprint
  fields :label_in_database

  field :stufen_allowed do |activity|
    activity.stufen.map(&:to_s)
  end
  # field :stufen_recommended do |activity|
  #   activity.stufen_recommended.map(&:to_s)
  # end
end
