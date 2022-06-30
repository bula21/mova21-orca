# frozen_string_literal: true

class UnitActivityExecutionFilter < ApplicationFilter
  attribute :activity
  attribute :unit
  attribute :activity_execution
  attribute :ids

  filter :id do |unit_activity_executions|
    ids = Array.wrap(ids).join(',').split(',')
    next if ids.blank?

    unit_activity_executions.where(id: ids)
  end

  filter :unit do |unit_activity_executions|
    next if unit.blank?

    unit_activity_executions.where(unit_id: unit.is_a?(Unit) ? unit.id : unit)
  end

  filter :activity_execution do |unit_activity_executions|
    next if activity_execution.blank?

    activity_execution_id = activity_execution.is_a?(ActivityExecution) ? activity_execution.id : activity_execution
    unit_activity_executions.where(activity_execution_id: activity_execution_id)
  end

  filter :activity do |unit_activity_executions|
    next if activity.blank?

    activity_id = activity.is_a?(Activity) ? activity.id : activity
    unit_activity_executions.joins(:activity_execution).where(activity_executions: { activity_id: activity_id })
  end
end
