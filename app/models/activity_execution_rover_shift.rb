# frozen_string_literal: true

class ActivityExecutionRoverShift < ApplicationRecord
  belongs_to :activity_execution, inverse_of: :activity_execution_rover_shifts
  belongs_to :rover_shift, inverse_of: :activity_execution_rover_shifts

  def self.replace(prev_rover_shift_id, new_rover_shift_id, activity_execution_id)
    return if activity_execution_id.blank?

    create!(activity_execution_id: activity_execution_id, rover_shift_id: new_rover_shift_id) if new_rover_shift_id
    return if prev_rover_shift_id.blank?

    where(activity_execution_id: activity_execution_id, rover_shift_id: prev_rover_shift_id).destroy_all
  end
end
