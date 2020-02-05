# frozen_string_literal: true

class UnitParser
  # TODO: Stufe wird mitgegeben aus iteration von uebergeordnetem Lager
  def initialize(data, stufe = 'pfadi')
    @unit_data = JSON.parse(data)
    @unit = Unit.new(stufe: stufe)
    @event = @unit_data['events'].first
    @linked = @unit_data['linked']
  end

  def call
    parse_linked
    parse_event
    parse_al
    parse_leader
    # TODO: add AL und Coach
    @unit.save!
    @unit
  end

  private

  def parse_linked
    @unit.abteilung = abteilung
    @unit.kv = kv
    @unit.starts_at = date('start_at')
    @unit.ends_at = date('finish_at')
  end

  def parse_event
    @unit.title = @event['name']
    @unit.expected_participants_f = expected_participants(@unit.stufe, 'f')
    @unit.expected_participants_m = expected_participants(@unit.stufe, 'm')
    @unit.expected_participants_leitung_f = expected_participants('leitung', 'f')
    @unit.expected_participants_leitung_m = expected_participants('leitung', 'm')
  end

  def parse_al
    person = find_person_by_id(@event['links']['abteilungsleitung'])
    @unit.al = find_or_create_leader(person)
  end

  def find_or_create_leader(person)
    # TODO: Import further attributes on TN-Import
    # TODO: What happens if a user is not used anymore? Are they cleaned up?
    leader = Leader.find_by(pbs_id: person['id'])
    return leader if leader

    Leader.create(pbs_id: person['id'], last_name: person['last_name'],
                  first_name: person['first_name'], scout_name: person['nickname'],
                  email: person['email'], address: person['address'], zip_code: person['zip_code'],
                  town: person['town'], country: person['country'])
  end

  def parse_leader
    person = find_person_by_id(@event['links']['leader'])
    @unit.lagerleiter = find_or_create_leader(person)
    # TODO: Import further attributes on TN-Import
  end

  def find_person_by_id(person_id)
    @linked['people'].find { |person| person['id'] == person_id }
  end

  def abteilung
    @linked['groups'].find { |group| group['group_type'] == 'Abteilung' }['name']
  end

  def kv
    @linked['groups'].find { |group| group['group_type'] == 'Kantonalverband' }['id']
  end

  def expected_participants(stufe, gender)
    if stufe == 'pta'
      Unit.stufen.keys.map { |s| (@event["expected_participants_#{s}_#{gender}"] || 0) }.sum
    else
      (@event["expected_participants_#{stufe}_#{gender}"] || 0)
    end
  end

  def date(name)
    @linked['event_dates'].first[name]
  end
end
