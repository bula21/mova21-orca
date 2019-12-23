# frozen_string_literal: true

class UnitParser
  def initialize(data)
    @data = data
  end

  def call
    unit_data = JSON.parse(@data)
    event = unit_data['events'].first
    linked = unit_data['linked']
    unit = Unit.new
    unit.stufe = stufe(unit_data)
    parse_linked(linked, unit)
    parse_event(event, unit)
    # TODO: add AL und Coach
    unit.save
    unit
  end

  private

  def parse_linked(linked, unit)
    unit.abteilung = abteilung(linked)
    unit.kv = kv(linked)
    unit.starts_at = date(linked, 'start_at')
    unit.ends_at = date(linked, 'finish_at')
  end

  def parse_event(event, unit)
    unit.title = event['name']
    unit.expected_participants_f = expected_participants(event, unit.stufe, 'f')
    unit.expected_participants_m = expected_participants(event, unit.stufe, 'm')
    unit.expected_participants_leitung_f = expected_participants(event, 'leitung', 'f')
    unit.expected_participants_leitung_m = expected_participants(event, 'leitung', 'm')
  end

  def abteilung(unit_data)
    unit_data['groups'].find { |group| group['group_type'] == 'Abteilung' }['name']
  end

  def kv(unit_data)
    unit_data['groups'].find { |group| group['group_type'] == 'Kantonalverband' }['id']
  end

  def stufe(_unit_data)
    # TODO: add logic
    # vom uebergeordneten lager
    'pfadi'
  end

  def expected_participants(unit_data, stufe, gender)
    if stufe == 'pta'
      Unit.stufen.keys.map { |s| (unit_data["expected_participants_#{s}_#{gender}"] || 0) }.sum
    else
      (unit_data["expected_participants_#{stufe}_#{gender}"] || 0)
    end
  end

  def date(unit_data, name)
    unit_data['event_dates'].first[name]
  end
end
