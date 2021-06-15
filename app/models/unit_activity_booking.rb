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

  def stufe
    # @stufe ||= Stufe.find_by(code: unit.stufe)
    Stufe.first
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

  def unit_activities(only: nil, without: nil)
    unit_activities = unit.unit_activities.joins(activity: [:activity_category])
    unit_activities = unit_activities.where(activity_categories: { code: only }) if only
    unit_activities = unit_activities.where.not(activity_categories: { code: without }) if without
    unit_activities
  end

  compliance_evaluator :ein_ausflug_pro_woche do
    next nil if weeks < 1

    activities = unit_activities.count
    activities == weeks || Rational(activities, weeks)
  end

  compliance_evaluator :max_eine_aktivitaet_pro_kategorie do
    category_counts = unit_activities(without: %i[village_global])
                      .pluck(:activity_category_id).tally

    category_counts.values.none? { _1 > 1 }
  end

  compliance_evaluator :eine_mova_aktivitaet_pro_woche do
    category_counts = unit_activities.pluck(:activity_category_id).tally

    category_counts.values.any? { _1 > 1 }
  end

  compliance_evaluator :village_global_workshops do
    count = unit_activities(only: :village_global).count

    # next nil if unit.stufe == 'pta'
    next false if count <= 0
    next Rational(count, 3) if count < 3

    true
  end
end
