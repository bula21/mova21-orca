class RoverShiftMatcher 
	def initialize(job_id, activity_executions = ActivityExecution.all, rover_shifts = RoverShift.all)
		@job_id = job_id
		@activity_executions = activity_executions.joins(:activity).where(activities: { rover_job_id: job_id })
		@rover_shifts = rover_shifts.where(job_id: job_id)
		@matched = {}
	end

	def call 
		delete_activity_executions_rover_shifts
		@activity_executions.reorder(Activity.arel_table[:rover_shift_prio]).map do |activity_execution|
			find_best_match_for(activity_execution)
		end.compact.each(&:save)
	end

	private

	def delete_activity_executions_rover_shifts
		ActivityExecutionRoverShift.where(activity_execution_id: @activity_executions.map(&:id)).delete_all
	end

	def find_best_match_for(activity_execution)
		best = nil
		best_overlap = 0

		@rover_shifts.each do |rover_shift|
			next if @matched[rover_shift.id].present?

			overlap = overlap_of(activity_execution, rover_shift)
			next if overlap <= best_overlap
			
			best_overlap = overlap
			best = ActivityExecutionRoverShift.new(rover_shift: rover_shift, activity_execution: activity_execution)
		end

		best
	end

	def overlap_of(activity_execution, rover_shift)
		return 0 unless activity_execution.at.overlaps?(rover_shift.at)

		start_delta = rover_shift.at.begin - activity_execution.at.begin
		end_delta = activity_execution.at.end - rover_shift.at.end
		delta = (start_delta.positive? ? 0 : start_delta) +  (end_delta.positive? ? 0 : end_delta) 
		return 1 if delta.zero?

		span = activity_execution.at.end - activity_execution.at.begin
		x= span / (span + delta)
		binding.pry
		span / (span + delta)
	end
end
