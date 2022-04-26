# frozen_string_literal: true

class UnitProgramChange < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_program_changes
  belongs_to :activity_execution, inverse_of: :unit_program_changes
  belongs_to :unit_activity_execution, inverse_of: :unit_program_changes

  attribute :notify, :boolean, default: false
  before_validation :set_associations
  after_save :send_notification

  def send_notification
    send_notification! if notify && notified_at.blank?
  end

  def send_notification!
    return unless valid?

    CampUnitMailer.with(unit_program_change_id: id).program_change_notification.deliver_now &&
      update!(notified_at: Time.zone.now)
  end

  def set_associations
    self.activity_execution ||= unit_activity_execution&.activity_execution
    self.unit ||= unit_activity_execution&.unit
  end
end
