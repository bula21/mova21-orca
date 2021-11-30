# frozen_string_literal: true

class UnitActivityExecution < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_activity_executions
  belongs_to :activity_execution, inverse_of: :unit_activity_executions
  has_one :activity, through: :activity_execution


  before_validation :prefill_headcount
  validates :unit_id, :activity_execution_id, presence: true
  validate do
    next if activity_execution.blank?

    available_headcount = activity_execution.available_headcount
    available_headcount += headcount_was.presence || 0
    errors.add(:headcount, :less_than, count: available_headcount) unless headcount <= available_headcount
  end

  def prefill_headcount
    return if unit.blank?

    role_counts = unit.participant_role_counts
    default_headcount = role_counts[:participant]
    default_headcount += role_counts[:assistant_leader] if activity_execution&.transport
    self.headcount = headcount.presence || default_headcount
  end
end
