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
  delegate :unit_activities, to: :unit
  attr_reader :unit

  COMPLIANT_VALUES = [true, 1].freeze

  def initialize(unit)
    @unit = unit
  end

  def open?
    FeatureToggle.enabled?(:unit_activity_booking)
  end

  def all_comply?
    compliance.values.compact.all? { COMPLIANT_VALUES.include?(_1) }
  end

  def compliance
    self.class.compliance_evaluators.transform_values do |evaluation_block|
      instance_exec(&evaluation_block)
    end
  end

  def weeks
    1 if unit.root_camp_unit&.stufe == :wolf
    1 if unit.root_camp_unit&.stufe == :pta
    2 if unit.root_camp_unit&.stufe == :pfadi
    0
  end

  def self.compliance_evaluators
    @compliance_evaluators ||= {}
  end

  def self.compliance_evaluator(name, &block)
    compliance_evaluators[name] = block
  end

  compliance_evaluator :ein_ausflug_pro_woche do
    next nil if weeks < 1

    activities = unit_activities.count
    activities == weeks || Rational(activities, weeks)
  end

  compliance_evaluator :eine_aktivitaet_pro_kategorie do
    category_counts = unit_activities.joins(:activity).pluck(:activity_category_id).tally

    category_counts.values.any? { _1 > 1 }
  end
end
