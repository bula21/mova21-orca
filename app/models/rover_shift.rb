# frozen_string_literal: true

class RoverShift < ApplicationRecord
  # has_many :activities, foreign_key: :rover_job_id, primary_key: :job_id
  has_many :activity_execution_rover_shifts, dependent: :destroy
  has_many :activity_executions, through: :activity_execution_rover_shifts

  def rover_count
    rovers&.count || 0
  end

  def rover_idle_count
    rover_count - rover_busy_count
  end

  def rover_busy_count
    Activity.where(id: activity_execution_ids).pluck(:required_rovers).compact.sum
  end

  def at
    starts_at..ends_at
  end
end
