# frozen_string_literal: true

class ActivityExecution < ApplicationRecord
  include Bitfields
  validates_with StartBeforeEndValidator

  belongs_to :activity, inverse_of: :activity_executions
  belongs_to :field, inverse_of: :activity_executions
  has_one :spot, through: :field
  has_many :unit_activity_executions, inverse_of: :activity_execution, dependent: :destroy

  validates :starts_at, :ends_at, presence: true
  validates :transport, inclusion: { in: [true, false] }
  validates :transport_ids, absence: { unless: :transport? }
  validates :mixed_languages, inclusion: { in: [true, false] }
  # TODO: check that at most the ones from activity_execution
  validates :language_flags, numericality: { greater_than: 0 }, allow_nil: false
  validates :amount_participants, numericality: { greater_than_or_equal_to: 0,
                                                  less_than_or_equal_to: :max_amount_participants }, allow_nil: false

  bitfield :language_flags, *Activity::LANGUAGES

  def max_amount_participants
    activity&.participants_count_activity || 0
  end

  def headcount
    unit_activity_executions.sum(:headcount)
  end

  def available_headcount
    max_amount_participants - headcount
  end

  def headcount_utilization
    return 1 if amount_participants.zero?

    headcount.to_d / amount_participants
  end

  def headcount_utilization_color
    case headcount_utilization * 100
    when 0..50
      'green'
    when 50..80
      'yellow'
    else
      'red'
    end
  end

  def languages
    bitfield_values(:language_flags)
  end

  def to_s
    super unless activity && starts_at.present?
    "#{activity.label}, #{I18n.l(starts_at)}"
  end
end
