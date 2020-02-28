# frozen_string_literal: true

class LeaderBuilder
  def from_data(person_data, id: person_data['id'])
    return unless person_data.present?

    leader = Leader.find_or_initialize_by(pbs_id: id)
    leader.update!(last_name: person_data['last_name'],
                   first_name: person_data['first_name'], scout_name: person_data['nickname'],
                   email: person_data['email'], address: person_data['address'],
                   zip_code: person_data['zip_code'],
                   town: person_data['town'], country: person_data['country'])
    leader
  end
end
