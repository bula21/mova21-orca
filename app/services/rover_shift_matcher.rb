# frozen_string_literal: true

class RoverShiftMatcher
  def initialize(job_id, activity_executions = ActivityExecution.all, rover_shifts = RoverShift.all)
    @job_id = job_id
    @activity_executions = activity_executions.joins(:activity).where(activities: { rover_job_id: job_id })
    @rover_shifts = rover_shifts.where(job_id: job_id).to_a
  end

  def call
    delete_activity_executions_rover_shifts
    @activity_executions.ordered_by_rover_shift_prio.filter_map do |activity_execution|
      find_best_match_for(activity_execution)
    end.each(&:save!)
  end

  private

  def delete_activity_executions_rover_shifts
    ActivityExecutionRoverShift.where(activity_execution_id: @activity_executions.map(&:id)).delete_all
  end

  def find_best_match_for(activity_execution)
    @rover_shifts.shuffle.each do |rover_shift|
      # required_rovers = activity_execution.activity.required_rovers
      # next unless required_rovers&.positive?
      # next unless activity_execution.unit_activity_executions.any?
      next unless rover_shift.at.cover?(activity_execution.at)

      # next unless rover_shift.rover_idle_count >= required_rovers

      return ActivityExecutionRoverShift.new(rover_shift: rover_shift, activity_execution: activity_execution)
    end
    nil
  end
end
