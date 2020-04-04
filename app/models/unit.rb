# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units, optional: true
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units
  has_many :participants
  # belongs_to :coach, class_name: 'Leader', inverse_of: :coach_units, optional: true
  has_many :invoices, inverse_of: :unit, dependent: :destroy

  validates :title, :kv_id, :lagerleiter, presence: true, on: :complete
  validates :expected_participants, numericality: { greater_than_or_equal_to: 12 }, on: :complete
  validates :expected_participants_leitung, numericality: { greater_than_or_equal_to: 2 }, on: :complete
  validate on: :complete do
    errors.add(:lagerleiter, :incomplete) unless lagerleiter.valid?(:complete)
  end

  before_save :set_limesurvey_token
  after_create do
    if complete?
      # notify_complete
    else
      notify_incomplete
    end
  end

  enum stufe: RootCampUnit.predefined.dup.transform_values(&:to_s)

  def kv
    Kv[kv_id]
  end
  delegate :locale, to: :kv

  def root_camp_unit
    RootCampUnit[stufe&.to_sym]
  end

  def expected_participants
    (expected_participants_f || 0) + (expected_participants_m || 0)
  end

  def expected_participants_leitung
    (expected_participants_leitung_f || 0) + (expected_participants_leitung_m || 0)
  end

  def complete?
    valid?(:complete)
  end

  def set_limesurvey_token
    return unless LimesurveyService.enabled? && complete?

    self.limesurvey_token ||= LimesurveyService.new.add_leader(lagerleiter, self)
  end

  def notify_incomplete
    return if complete?

    CampUnitMailer.with(camp_unit_id: id).incomplete_notification.deliver_now
  end

  def notify_complete
    return unless complete?

    CampUnitMailer.with(camp_unit_id: id).complete_notification.deliver_now
  end

  def limesurvey_url
    @limesurvey_url ||= LimesurveyService.new.url(token: limesurvey_token, lang: lagerleiter.language)
  end
end
