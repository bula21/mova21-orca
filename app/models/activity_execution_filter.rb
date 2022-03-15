# frozen_string_literal: true

class ActivityExecutionFilter < ApplicationFilter
  attribute :activity
  attribute :field
  attribute :spot

  filter :field do |activity_executions|
    next if field.blank?

    activity_executions.joins(:field).where(fields: { id: field })
  end

  filter :spot do |activity_executions|
    next if spot.blank?

    activity_executions.joins(:field).where(fields: { spot_id: spot })
  end

  filter :activity do |activity_executions|
    next if spot.blank?

    activity_executions.where(activity_id: activity)
  end
end
