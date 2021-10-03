# frozen_string_literal: true

class ActivityExecution < ApplicationRecord
  include Bitfields
  validates_with StartBeforeEndValidator

  belongs_to :activity, inverse_of: :activity_executions
  belongs_to :field, inverse_of: :activity_executions
  has_one :spot, through: :field
  validates :starts_at, :ends_at, presence: true
  validates :transport, inclusion: { in: [true, false] }
  # TODO: check that at most the ones from activity_execution
  validates :language_flags, numericality: { greater_than: 0 }, allow_nil: false
  validates :amount_participants, numericality: { greater_than_or_equal_to: 0,
                                                  less_than_or_equal_to: :max_amount_participants }, allow_nil: false

  bitfield :language_flags, *Activity::LANGUAGES

  def max_amount_participants
    activity&.participants_count_activity || 0
  end

  def languages
    bitfield_values(:language_flags)
  end
end
