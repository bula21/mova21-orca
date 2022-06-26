# frozen_string_literal: true

class UnitActivityExecutionsExporter
  attr_reader :unit_activity_executions

  HEADERS = %w[
    unit_activity_id
    unit_id
    unit_name
    activity_id
    activity_name
    activity_category
    activity_execution_id
    activity_starts_at
    activity_ends_at
    activity_spot_id
    activity_spot_name
    activity_field_id
    activity_field_name
    activity_languages
    activity_max_headcount
    activity_headcount
    activity_transport
    activity_transport_ids
  ].freeze

  def initialize(unit_activity_executions)
    @unit_activity_executions = unit_activity_executions
  end

  def export
    CSV.generate(headers: true) do |csv|
      csv << HEADERS
      @unit_activity_executions.each { |unit_activity_execution| csv << attributes(unit_activity_execution) }
    end
  end

  def filename
    "unit_activity_executions-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def attributes(unit_activity_execution)
    [
      unit_activity_execution.id,

      unit_activity_execution.unit_id,
      unit_activity_execution.unit.title,

      unit_activity_execution.activity_execution.activity_id,
      unit_activity_execution.activity_execution.activity.to_s,
      unit_activity_execution.activity_execution.activity.activity_category.to_s,

      unit_activity_execution.activity_execution_id,
      unit_activity_execution.activity_execution.starts_at.iso8601,
      unit_activity_execution.activity_execution.ends_at.iso8601,
      unit_activity_execution.activity_execution.spot.id,
      unit_activity_execution.activity_execution.spot.name,
      unit_activity_execution.activity_execution.field_id,
      unit_activity_execution.activity_execution.field.name,
      unit_activity_execution.activity_execution.languages.filter_map { |key, value| key if value }.join(','),
      unit_activity_execution.activity_execution.amount_participants,
      unit_activity_execution.activity_execution.headcount,
      unit_activity_execution.activity_execution.transport,
      unit_activity_execution.activity_execution.transport_ids
    ]
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize
end
