# frozen_string_literal: true

class CheckpointUnitsExporter
  attr_reader :checkpoint_units

  HEADERS = %w[
    id
    unit_id
    unit_name
    district_number
    language
    week_nr
    checkpoint
    notes_check_in
    checked_in_on_paper
    check_in_by
    confirmed_checked_in_at
    confirmed_check_in_by
    notes_check_out
    check_out_ok
    cost_in_chf
    checked_out_at
    check_out_by
    checked_out_on_paper
    confirmed_checked_out_at
    confirmed_check_out_by
  ].freeze

  def initialize(checkpoint_units)
    @checkpoint_units = checkpoint_units
  end

  def export
    CSV.generate(headers: true) do |csv|
      csv << HEADERS
      @checkpoint_units.each { |checkpoint_unit| csv << attributes(checkpoint_unit) }
    end
  end

  def filename
    "checkpoint_units-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def attributes(checkpoint_unit)
    checkpoint_unit.instance_eval do
      [
        id,
        unit.id,
        unit.shortened_title,
        unit.district_nr,
        unit.language,
        unit.week_nr,
        checkpoint.title,
        notes_check_in,
        checked_in_on_paper,
        checked_in_at&.iso8601,
        check_in_by&.full_name,
        confirmed_checked_in_at&.iso8601,
        confirmed_check_in_by&.full_name,
        notes_check_out,
        check_out_ok,
        cost_in_chf,
        checked_out_at&.iso8601,
        check_out_by&.full_name,
        checked_out_on_paper,
        confirmed_checked_out_at&.iso8601,
        confirmed_check_out_by&.full_name
      ]
    end
  end

  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
