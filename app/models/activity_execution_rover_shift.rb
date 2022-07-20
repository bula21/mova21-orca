class ActivityExecutionRoverShift < ApplicationRecord
	belongs_to :activity_execution, inverse_of: :activity_execution_rover_shifts
	belongs_to :rover_shift, inverse_of: :activity_execution_rover_shifts
end
