# frozen_string_literal: true

class UnitBlueprint < Blueprinter::Base
  identifier :id

  fields :language, :stufe, :week, :starts_at, :ends_at, :participant_role_counts, :district
  field :unit_activities do |unit|
    unit.unit_activities.rank(:priority).map do |unit_activity|
      { priority: unit_activity.priority_rank, activity_id: unit_activity.activity_id }
    end
  end
end
