# frozen_string_literal: true

class RoverShiftsExporter
  attr_reader :rover_shifts

  HEADERS = [
    'Durchführungs ID',
    'Aktivitäts ID',
    'Aktivität',
    'Durchführung von',
    'Durchführung bis',
    'Rover Schicht ID',
    'Rover Schicht von',
    'Rover Schicht bis',
    'Rover IDs'
  ].freeze

  def initialize(rover_shifts)
    @rover_shifts = rover_shifts
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def export
    CSV.generate(headers: true) do |csv|
      csv << HEADERS
      ActivityExecutionRoverShift.where(rover_shift: @rover_shifts).each do |activity_execution_rover_shift|
        csv << activity_execution_rover_shift.instance_eval do
          [
            activity_execution_id,
            activity_execution.activity_id,
            activity_execution.activity,
            activity_execution.starts_at.iso8601,
            activity_execution.ends_at.iso8601,
            rover_shift.id,
            rover_shift.starts_at&.iso8601,
            rover_shift.ends_at&.iso8601,
            rover_shift.rovers.join(', ')
          ]
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def filename
    "rover_shifts-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end
end
