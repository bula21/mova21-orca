# frozen_string_literal: true

class UnitActivityExecutionsExporter
  attr_reader :unit_activity_executions

  HEADERS = %w[
    unit_activity_id
    activity_id
    activity_execution_id
    unit_id
    headcount
    unit_name
    unit_stufe
    unit_language
    unit_abteilung
    activity_name
    activity_category
    activity_starts_at
    activity_ends_at
    activity_spot_id
    activity_spot_name
    activity_field_id
    activity_field_name
    activity_languages
    activity_max_headcount
    activity_transport
    activity_transport_ids
  ].freeze

  def initialize(unit_activity_executions)
    @unit_activity_executions = unit_activity_executions.includes(:unit, activity_execution:
                                                                  [:spot, :field, { activity: [:activity_category] }])
  end

  def export
    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << HEADERS
      @unit_activity_executions.each { |unit_activity_execution| csv << attributes(unit_activity_execution) }
    end
  end

  def filename
    "unit_activity_executions-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
  def attributes(unit_activity_execution)
    unit_activity_execution.instance_eval do
      Rails.cache.fetch(cache_key) do
        [
          id,
          activity_execution.activity_id,
          activity_execution_id,
          unit_id,
          headcount,
          unit.instance_eval do
            [
              title,
              stufe,
              language,
              abteilung
            ]
          end,
          activity_execution.instance_eval do
            [
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
        ].flatten
      end
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
end
