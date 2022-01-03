# frozen_string_literal: true

class CampUnitValidator < ActiveModel::Validator
  def validate(record)
    # record.errors.add :base, "This is some custom error message"
    # record.errors.add :first_name, "This is some complex validation"
  end
end
