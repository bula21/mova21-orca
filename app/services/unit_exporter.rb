# frozen_string_literal: true

class UnitExporter
  attr_reader :units

  HEADERS = %w[
    id
    pbs_id
    title
    abteilung
    kv_id
    stufe
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
    lagerleiter_birthdate
    lagerleiter_gender
    lagerleiter_email
    lagerleiter_phone_number
    lagerleiter_language
    lagerleiter_address
    lagerleiter_zip_code
    lagerleiter_town
    lagerleiter_country
    al_pbs_id
    al_last_name
    al_first_name
    al_scout_name
    al_birthdate
    al_gender
    al_email
    al_phone_number
    al_language
    al_address
    al_zip_code
    al_town
    al_country
    coach_id
    coach_last_name
    coach_first_name
    coach_scout_name
    coach_email
  ].freeze

  def initialize(units)
    @units = units
  end

  def export
    CSV.generate(headers: true) do |csv|
      csv << (HEADERS )
      @units.each { |unit| csv << unit_attributes(unit) }
    end
  end

  def filename
    "units-#{Time.zone.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def unit_attributes(unit)
    [
      unit.id,
      unit.pbs_id,
      unit.title,
      unit.abteilung,
      unit.kv_id,
      unit.stufe,
      unit.expected_participants_f, unit.expected_participants_m,
      unit.expected_participants_leitung_f, unit.expected_participants_leitung_m,
      unit.starts_at, unit.ends_at,
      unit.language,
      unit.lagerleiter.pbs_id, unit.lagerleiter.last_name, unit.lagerleiter.first_name, unit.lagerleiter.scout_name,
      unit.lagerleiter.birthdate, unit.lagerleiter.gender, unit.lagerleiter.email, unit.lagerleiter.phone_number,
      unit.lagerleiter.language, unit.lagerleiter.address, unit.lagerleiter.zip_code, unit.lagerleiter.town,
      unit.lagerleiter.country,
      unit.al&.pbs_id, unit.al&.last_name, unit.al&.first_name, unit.al&.scout_name,
      unit.al&.birthdate, unit.al&.gender, unit.al&.email, unit.al&.phone_number, unit.al&.language,
      unit.al&.address, unit.al&.zip_code, unit.al&.town, unit.al&.country,
      unit.coach_id, unit.coach&.last_name, unit.coach&.first_name, unit.coach&.scout_name, unit.coach&.email
    ] + unit.participant_role_counts.values
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
