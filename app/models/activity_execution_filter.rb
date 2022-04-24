# frozen_string_literal: true

class ActivityExecutionFilter < ApplicationFilter
  attribute :activity
  attribute :field
  attribute :spot
  attribute :starts_at_after, :datetime
  # attribute :starts_at_before, :datetime
  # attribute :ends_at_before, :datetime
  attribute :ends_at_before, :datetime
  attribute :min_available_headcount, :integer
  attribute :max_units, :integer

  filter :field do |activity_executions|
    next if field.blank?

    activity_executions.joins(:field).where(fields: { id: field })
  end

  filter :spot do |activity_executions|
    next if spot.blank?

    activity_executions.joins(:field).where(fields: { spot_id: spot })
  end

  filter :activity do |activity_executions|
    next if activity.blank?

    activity_executions.where(activity_id: activity)
  end

  filter :starts_at_after do |activity_executions|
    next if starts_at_after.blank?

    activity_executions.where(ActivityExecution.arel_table[:starts_at].gt(starts_at_after))
  end

  filter :ends_at_before do |activity_executions|
    next if ends_at_before.blank?

    activity_executions.where(ActivityExecution.arel_table[:ends_at].lt(ends_at_before))
  end

  filter :min_available_headcount do |activity_executions|
    next if min_available_headcount.blank?

    outer_join_activity_execution_and_unit_activity_execution(activity_executions)
      .having(Arel::Nodes::Subtraction.new(
        coalesce(ActivityExecution.arel_table[:amount_participants], 0),
        coalesce(UnitActivityExecution.arel_table[:headcount].sum, 0)
      ).gt(min_available_headcount))
  end

  filter :max_units do |activity_executions|
    next if max_units.blank?

    outer_join_activity_execution_and_unit_activity_execution(activity_executions)
      .having(UnitActivityExecution.arel_table[:id].count.lteq(max_units))
  end

  def coalesce(*args)
    Arel::Nodes::NamedFunction.new('COALESCE', args)
  end

  def outer_join_activity_execution_and_unit_activity_execution(relation)
    activity_execution = ActivityExecution.arel_table
    unit_activity_execution = UnitActivityExecution.arel_table
    join_on = activity_execution.create_on(unit_activity_execution[:activity_execution_id].eq(activity_execution[:id]))
    relation.joins(activity_execution.create_join(unit_activity_execution, join_on, Arel::Nodes::OuterJoin))
            .group(ActivityExecution.arel_table[:id])
  end
end
