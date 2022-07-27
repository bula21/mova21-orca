# frozen_string_literal: true

class ActivityExporter
  include BaseExporter

  attr_reader :activities

  HEADERS = %w[
    id
    activity_type
    block_type
    duration_activity
    duration_journey
    label_de
    label_fr
    label_it
    language
    location
    min_participants
    participants_count_activity
    participants_count_transport
    simo
    transport_location_id
    stufe
    stufe_recommended
  ].freeze

  def initialize(activities)
    @activities = activities
  end

  def export
    BOM_UTF_8_CHARACTER + CSV.generate(headers: true) do |csv|
      csv << HEADERS
      @activities.each { |activity| csv << attributes(activity) }
    end
  end

  def filename
    "activities-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def attributes(activity)
    activity.instance_eval do
      Rails.cache.fetch(cache_key) do
        [
          id,
          activity_type,
          block_type,
          duration_activity,
          duration_journey,
          label_de,
          label_fr,
          label_it,
          Array.wrap(language_keys).join(', '),
          location,
          min_participants,
          participants_count_activity,
          participants_count_transport,
          simo,
          transport_location_id,
          Array.wrap(stufen).join(', '),
          Array.wrap(stufe_recommended).join(', ')
        ]
      end
    end
  end

  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize
end
