# frozen_string_literal: true

class UnitActivityExecution < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_activity_executions
  belongs_to :activity_execution, inverse_of: :unit_activity_executions
  has_one :activity, through: :activity_execution
  has_many :unit_program_changes, inverse_of: :unit_activity_execution, dependent: :nullify

  scope :with_default_includes, -> { includes(:activity_execution, :unit) }
  scope :ordered, -> { joins(:activity_execution).order(ActivityExecution.arel_table[:starts_at]) }

  attribute :change_notification, :boolean, default: false
  attribute :track_changes_enabled, :boolean, default: true
  attribute :change_remarks, :string

  before_validation :prefill_headcount
  after_save :track_changes

  def track_changes
    unit_program_changes.create(notify: change_notification, remarks: change_remarks) if track_changes_enabled?
  end

  def prefill_headcount
    return if unit.blank?

    role_counts = unit.participant_role_counts
    default_headcount = role_counts[:participant]
    default_headcount += role_counts[:assistant_leader] if activity_execution&.transport
    self.headcount = headcount.presence || default_headcount
  end
end
