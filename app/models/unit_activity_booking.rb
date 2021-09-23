# frozen_string_literal: true

# Generell
#  - Pro Kategorie nur eine Aktivitat (Wasser, etc)
#  - "egal" geht nicht wegen Leistungsniveaus, Ausbildungen etc.
#
# Liste "Ausflug"
# - 1 Ausflug pro Woche muss ausgewahlt werden
# - 1 Ausflug muss eine Wanderung sein wenn man 2 Wochen da ist
#
# Liste "Village Global"
# - 1x Village Global
# - Village Global findet eine Woche in DE und eine in FR statt
# - fur die PTA freiwillig (mail von tux) => sie konnen noch eine weitere LS/LA wahlen
#
# Liste "mova-Aktivitat"
class UnitActivityBooking
  attr_reader :unit

  COMPLIANT_VALUES = [true, 1].freeze

  def initialize(unit)
    @unit = unit
  end

  def all_comply?
    compliance.values.compact.all? { COMPLIANT_VALUES.include?(_1) }
  end

  def compliance
    self.class.compliance_evaluators.transform_values do |evaluation_block|
      instance_exec(&evaluation_block)
    end
  end

  def phase?(*phases)
    phases&.map(&:to_sym)&.include?(unit.activity_booking_phase&.to_sym)
  end

  def weeks
    {
      wolf: 1,
      pta: 1,
      pfadi: 2,
      pio: 2
    }.fetch(stufe, 0)
  end

  def stufe
    unit&.stufe&.to_sym
  end

  def stufe_pio?
    stufe == :pio
  end

  def stufe_pfadi?
    stufe == :pfadi
  end

  def stufe_wolf?
    stufe == :wolf
  end

  def stufe_pta?
    stufe == :pta
  end

  def self.compliance_evaluators
    @compliance_evaluators ||= {}
  end

  def self.compliance_evaluator(name, &block)
    compliance_evaluators[name] = block
  end

  def include?(activity)
    @activity_ids ||= unit.unit_activities.pluck(:activity_id)
    @activity_ids.include?(activity.is_a?(Integer) ? activity : activity&.id)
  end

  def commit
    unit.erros.add(:visitor_day_tickets) if unit.visitor_day_tickets.blank?
    unit.activity_booking_phase_committed! if all_comply? && unit.valid?

    phase?(:committed)
  end

  def unit_activities(only: nil, without: nil)
    unit_activities = unit.unit_activities.joins(activity: [:activity_category])
    unit_activities = unit_activities.where(activity_categories: { code: only }) if only
    unit_activities = unit_activities.where.not(activity_categories: { code: without }) if without
    unit_activities
  end

  compliance_evaluator :phase_open do
    phase?(:open)
  end

  compliance_evaluator :hiking do
    next nil unless stufe_pfadi? || stufe_pio?

    activities = unit_activities(only: :hiking).count
    activities >= (weeks * 3) || "#{activities}/#{weeks * 3}"
  end

  compliance_evaluator :excursions do
    next nil unless stufe_pfadi? || stufe_pio?

    activities = unit_activities(only: %i[excursion water culture]).count
    activities >= (weeks * 3) || "#{activities}/#{weeks * 3}"
  end

  compliance_evaluator :hiking_or_excursions do
    next nil unless stufe_wolf? || stufe_pta?

    activities = unit_activities(only: %i[excursion water culture hiking]).count
    activities >= (weeks * 3) || "#{activities}/#{weeks * 3}"
  end

  compliance_evaluator :visitor_day do
    next nil if weeks < 2

    count = unit_activities(only: :visitor_day).count
    count >= 1 || '0/1'
  end

  compliance_evaluator :mova_activities do
    next nil if weeks < 1

    count = unit_activities(without: %i[village_global water culture taufe excursion hiking]).count
    count >= (weeks * 4) || "#{count}/#{weeks * 4}"
  end

  compliance_evaluator :village_global_workshops do
    next nil if stufe_pta?

    count = unit_activities(only: :village_global).count
    count >= 3 || "#{count}/3"
  end
end
