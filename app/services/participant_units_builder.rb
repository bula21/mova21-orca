# frozen_string_literal: true

class ParticipantUnitsBuilder
  include ImportHelper

  def assignable_attributes(participation_data)
    {
      first_name: participation_data['first_name'],
      last_name: participation_data['last_name'],
      scout_name: participation_data['nickname'],
      email: participation_data['email'],
      phone_number: mobile_phone(participation_data),
      gender: convert_gender(participation_data),
      birthdate: participation_data['birthday']
    }
  end

  def from_data(participations_data, camp_unit)
    return [] if participations_data.empty?

    participations_data.map { |d| participant_unit_from_data(d, camp_unit) }
  end

  private

  def first_mobile_looking_number(phone_numbers)
    phone_numbers.map { |p| p['number'] }.find { |number| number =~ /^((\+|00)41 ?|0)7[5-9]/ }
  end

  def mobile_phone(participation_data)
    phone_numbers = participation_data['phone_numbers']

    return if phone_numbers.blank?

    first_mobile_looking_number(phone_numbers)
  end

  def role(participation_data)
    role_types = participation_data['roles'].map { |r| r['type'] }.uniq
    warn_if_multiple_roles(participation_data['id'], role_types)
    role_types.min_by { |role| ParticipantUnit::MIDATA_EVENT_CAMP_ROLES.values.index(role) }
  end

  def warn_if_multiple_roles(pbs_id, role_types)
    return unless role_types.size > 1

    ErrorLogger.capture_message("User with pbs_id #{pbs_id} has multiple roles in participation: #{role_types}",
                                level: 'warning')
  end

  def convert_gender(participation_data)
    gender = participation_data['gender']
    { 'w' => Participant.genders['female'], 'm' => Participant.genders['male'] }[gender]
  end

  def participant_unit_from_data(participation_data, camp_unit)
    participant = Participant.find_or_initialize_by(pbs_id: participation_data.dig('links', 'person'))
    participant.assign_attributes(assignable_attributes(participation_data))
    save_or_log_if_persisted_and_changed(participant)
    participant_unit = ParticipantUnit.find_or_initialize_by(participant: participant, unit: camp_unit)
    participant_unit.participant = participant
    participant_unit.role = role(participation_data)
    save_or_log_if_persisted_and_changed(participant_unit)
    participant_unit
  end
end
