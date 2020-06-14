# frozen_string_literal: true

class ParticipantsBuilder
  def assignable_attributes(participation_data)
    {
      first_name: participation_data.dig('first_name'),
      last_name: participation_data.dig('last_name'),
      scout_name: participation_data.dig('nickname'),
      role: role(participation_data),
      gender: convert_gender(participation_data),
      birthdate: participation_data.dig('birthday')
    }
  end

  def from_data(participations_data)
    return [] if participations_data.empty?

    participations_data.map(&method(:participant_from_data))
  end

  private

  def role(participation_data)
    roles = participation_data['roles']
    warn_if_multiple_roles(participation_data['id'], roles)
    roles.first['type']
  end

  def warn_if_multiple_roles(pbs_id, roles)
    return unless Rollbar.configuration.enabled && roles.size > 1

    Rollbar.warning "User with pbs_id #{pbs_id} has multiple roles in participation: #{roles.map { |r| r['type'] }}"
  end

  def convert_gender(participation_data)
    gender = participation_data.dig('gender')
    { 'f' => Participant.genders['female'], 'm' => Participant.genders['male'] }[gender]
  end

  def participant_from_data(participation_data)
    participant = Participant.find_or_initialize_by(pbs_id: participation_data['id'])
    participant.assign_attributes(assignable_attributes(participation_data))
    participant
  end
end
