# frozen_string_literal: true

class UnitContactLog < ApplicationRecord
  belongs_to :user, inverse_of: :unit_contact_logs
  belongs_to :unit, inverse_of: :unit_contact_logs
end
