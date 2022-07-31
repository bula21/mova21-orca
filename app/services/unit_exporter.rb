# frozen_string_literal: true

class UnitExporter
  include BaseExporter

  attr_reader :units

  HEADERS = %w[
    id
    pbs_id
    title
    abteilung
    kv_id
    stufe
    week_nr
    district_nr
    district
    expected_participants_f
    expected_participants_m
    expected_participants_leitung_f
    expected_participants_leitung_m
    starts_at
    ends_at
    language
    lagerleiter_pbs_id
    lagerleiter_last_name
    lagerleiter_first_name
    lagerleiter_scout_name
    al_pbs_id
    al_last_name
    al_first_name
    al_scout_name
    coach_id
    coach_last_name
    coach_first_name
    coach_scout_name
  ].freeze

  def initialize(units)
    @units = units
  end

  def export
    BOM_UTF_8_CHARACTER + CSV.generate(headers: true) do |csv|
      csv << (HEADERS + ParticipantUnit::MIDATA_EVENT_CAMP_ROLES.keys)
      @units.each { |unit| csv << unit_attributes(unit) }
    end
  end

  def filename
    "units-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
  def unit_attributes(unit)
    [
      unit.id,
      unit.pbs_id,
      unit.title,
      unit.abteilung,
      unit.kv_id,
      unit.stufe,
      unit.week_nr,
      unit.district_nr,
      unit.district,
      unit.expected_participants_f, unit.expected_participants_m,
      unit.expected_participants_leitung_f, unit.expected_participants_leitung_m,
      unit.starts_at, unit.ends_at,
      unit.language,
      unit.lagerleiter.pbs_id, unit.lagerleiter.last_name, unit.lagerleiter.first_name, unit.lagerleiter.scout_name,
      unit.al&.pbs_id, unit.al&.last_name, unit.al&.first_name, unit.al&.scout_name,
      unit.coach_id, unit.coach&.last_name, unit.coach&.first_name, unit.coach&.scout_name
    ] + unit.participant_role_counts.values
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
end
