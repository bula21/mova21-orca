# frozen_string_literal: true

class ActivityExecutionFilter < ApplicationFilter
  attribute :activity_id
  attribute :field_id
  attribute :spot_id
  attribute :starts_at_after, :datetime
  attribute :ends_at_before, :datetime
  attribute :date, :date
  attribute :min_available_headcount, :integer
  attribute :max_units, :integer

  filter :field do |activity_executions|
    next if field_id.blank?

    activity_executions.joins(:field).where(fields: { id: field_id })
  end

  filter :spot do |activity_executions|
    next if spot_id.blank?

    activity_executions.joins(:field).where(fields: { spot_id: spot_id })
  end

  filter :activity do |activity_executions|
    next if activity_id.blank?

    activity_executions.where(activity_id: activity_id)
  end

  filter :starts_at_after do |activity_executions|
    next if starts_at_after.blank?

    activity_executions.where(arel_table[:starts_at].gt(starts_at_after))
  end

  filter :ends_at_before do |activity_executions|
    next if ends_at_before.blank?

    activity_executions.where(arel_table[:ends_at].lt(ends_at_before))
  end

  filter :date do |activity_executions|
    next unless date.is_a?(Date)

    activity_executions.where(arel_table[:starts_at].gt(date.beginning_of_day),
                              arel_table[:ends_at].lt(date.end_of_day))
  end

  filter :min_available_headcount do |activity_executions|
    next if min_available_headcount.blank?

    outer_join_activity_execution_and_unit_activity_execution(activity_executions)
      .having(Arel::Nodes::Subtraction.new(
        coalesce(arel_table[:amount_participants], 0),
        coalesce(UnitActivityExecution.arel_table[:headcount].sum, 0)
      ).gt(min_available_headcount))
  end

  filter :max_units do |activity_executions|
    next if max_units.blank?

    outer_join_activity_execution_and_unit_activity_execution(activity_executions)
      .having(UnitActivityExecution.arel_table[:id].count.lteq(max_units))
  end

  private

  def arel_table
    ActivityExecution.arel_table
  end

  def coalesce(*args)
    Arel::Nodes::NamedFunction.new('COALESCE', args)
  end

  def outer_join_activity_execution_and_unit_activity_execution(relation)
    unit_activity_execution = UnitActivityExecution.arel_table
    join_on = arel_table.create_on(unit_activity_execution[:activity_execution_id].eq(arel_table[:id]))
    relation.joins(arel_table.create_join(unit_activity_execution, join_on, Arel::Nodes::OuterJoin))
            .group(arel_table[:id])
  end
end
