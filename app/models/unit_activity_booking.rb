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
# - fur die PTA freiwillig (mail von tux) => sie können noch eine weitere LS/LA wählen
#
# Liste "mova-Aktivitat"
class UnitActivityBooking
  class Score
    attr_reader :numerator, :denominator, :ok

    def initialize(numerator, denominator = 1, ok: numerator == denominator)
      @numerator = numerator
      @denominator = denominator
      @ok = ok
    end

    def to_s
      "#{numerator}/#{denominator}"
    end
  end

  delegate :unit_activities, to: :unit
  attr_reader :unit

  def initialize(unit)
    @unit = unit
  end

  def open?
    FeatureToggle.enabled?(:unit_activity_booking)
  end

  def fullfilled?
    fullfillments.values.all? { _1.nil? || _1.ok }
  end

  def fullfillments
    @fullfillments ||= self.class.rules.transform_values do |rule_block|
      instance_exec(&rule_block)
    end
  end

  def self.rules
    @rules ||= {}
  end

  def self.rule(name, &rule_block)
    rules[name] = rule_block
  end

  rule :ein_ausflug_pro_woche do
    weeks = 2
    activities = unit_activities.count
    Score.new(activities, weeks)
  end
end
