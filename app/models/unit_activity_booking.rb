# frozen_string_literal: true

class UnitActivityBooking
  def initialize(unit)
    @unit = unit
  end

  def open?
    FeatureToggle.enabled?(:unit_activity_booking)
  end

  def complete?
    false
  end
end
