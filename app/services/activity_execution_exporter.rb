# frozen_string_literal: true

class ActivityExecutionExporter
  attr_reader :activity_executions

  HEADERS = %w[
    id
    activity_id
    activity_name
    activity_category
    starts_at
    ends_at
    spot_id
    spot_name
    field_id
    field_name
    languages
    max_headcount
    transport
    transport_ids
  ].freeze

  def initialize(activity_executions)
    @activity_executions = activity_executions
  end

  def export

    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << HEADERS
      @activity_executions.each { |activity_execution| csv << attributes(activity_execution) }
    end
  end

  def filename
    "activity_executions-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def attributes(activity_execution)
    activity_execution.instance_eval do
      Rails.cache.fetch(cache_key) do
        [
          id,
          activity_id,
          activity.to_s,
          activity.activity_category.to_s,
          starts_at.iso8601,
          ends_at.iso8601,
          spot.id,
          spot.name,
          field_id,
          field.name,
          languages.filter_map { |key, value| key if value }.join(','),
          amount_participants,
          transport,
          transport_ids
        ]
      end
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize
end
