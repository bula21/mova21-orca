# frozen_string_literal: true

class ParticipationBuilder
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

  def from_data(participations_data)
    return [] if participations_data.empty?

    participations_data.flat_map { |participation_data| participation_from_data(participation_data) }
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

  def roles(participation_data)
    participation_data['roles'].map { |r| r['type'] }.uniq
  end

  def convert_gender(participation_data)
    gender = participation_data['gender']
    { 'w' => Participant.genders['female'], 'm' => Participant.genders['male'] }[gender]
  end

  def participation_from_data(participation_data)
    participant = Participant.find_or_initialize_by(pbs_id: participation_data.dig('links', 'person'))
    participant.assign_attributes(assignable_attributes(participation_data))
    roles(participation_data).map do |role|
      ParticipantUnit.new(participant: participant, role: role)
    end
  end
end
