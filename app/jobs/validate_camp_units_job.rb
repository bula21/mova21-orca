# frozen_string_literal: true

class ValidateCampUnitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    validator = CampUnitValidator.new

    Unit.find_each do |camp_unit|
      validator.validate_and_notify(camp_unit)
    end
  end
end
