# frozen_string_literal: true

class UnitParser
  # TODO: Stufe wird mitgegeben aus iteration von übergeordnetem Lager
  def initialize(data, stufe = 'pfadi')
    @unit_data = JSON.parse(data)
    @unit = Unit.new(stufe: stufe)
    @event = @unit_data['events'].first
    @linked = @unit_data['linked']
  end

  def call
    parse_linked
    parse_event
    # TODO: add AL und Coach
    @unit.save
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
