# frozen_string_literal: true

# == Schema Information
#
# Table name: units
#
#  id                              :bigint           not null, primary key
#  abteilung                       :string
#  district                        :string
#  ends_at                         :datetime
#  expected_participants_f         :integer
#  expected_participants_leitung_f :integer
#  expected_participants_leitung_m :integer
#  expected_participants_m         :integer
#  language                        :string
#  limesurvey_token                :string
#  midata_data                     :jsonb
#  starts_at                       :datetime
#  stufe                           :string
#  title                           :string
#  week                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  al_id                           :bigint
#  coach_id                        :bigint
#  kv_id                           :integer
#  lagerleiter_id                  :bigint           not null
#  pbs_id                          :integer
#
# Indexes
#
#  index_units_on_al_id           (al_id)
#  index_units_on_coach_id        (coach_id)
#  index_units_on_lagerleiter_id  (lagerleiter_id)
#
# Foreign Keys
#
#  fk_rails_...  (al_id => leaders.id)
#  fk_rails_...  (coach_id => leaders.id)
#  fk_rails_...  (lagerleiter_id => leaders.id)
#
class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units, optional: true
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units
  belongs_to :coach, class_name: 'Leader', inverse_of: :coach_units, optional: true
  belongs_to :kv, inverse_of: :units, primary_key: :pbs_id
  belongs_to :kv, inverse_of: :units, primary_key: :pbs_id

  has_many :invoices, inverse_of: :unit, dependent: :destroy
  has_many :invoices, inverse_of: :unit, dependent: :destroy
  has_many :unit_activities, -> { rank(:priority) }, inverse_of: :unit, dependent: :destroy
  has_many :participant_units, inverse_of: :unit, dependent: :destroy
  has_many :participants, -> { order(role: :asc, last_name: :asc, scout_name: :asc) },
           through: :participant_units, inverse_of: :units, dependent: :destroy
  has_many :unit_activity_executions, inverse_of: :unit, dependent: :destroy
  has_one :unit_visitor_day, inverse_of: :unit, dependent: :destroy

  has_many_attached :documents

  validates :title, :kv_id, :lagerleiter, presence: true, on: :complete
  validates :expected_participants, numericality: { greater_than_or_equal_to: 12 }, on: :complete
  validates :expected_participants_leitung, numericality: { greater_than_or_equal_to: 2 }, on: :complete
  validates :visitor_day_tickets, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate on: :complete do
    errors.add(:lagerleiter, :incomplete) unless lagerleiter.valid?(:complete)
  end

  before_save :set_limesurvey_token
  after_create :notify_incomplete
  accepts_nested_attributes_for :participants

  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en' }
  enum activity_booking_phase: { closed: 0, preview: 1, open: 2, committed: 3 }, _prefix: true

  delegate :locale, to: :kv

  def expected_participants
    (expected_participants_f || 0) + (expected_participants_m || 0) + (expected_guest_participants || 0)
  end

  def expected_participants_leitung
    (expected_participants_leitung_f || 0) + (expected_participants_leitung_m || 0) + (expected_guest_leaders || 0)
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

  def activity_booking
    @activity_booking ||= UnitActivityBooking.new(self)
  end

  def participant_role_counts
    baseline = ParticipantUnit::MIDATA_EVENT_CAMP_ROLES.transform_values { 0 }
    participant_units.group_by(&:role).transform_values(&:count).symbolize_keys.reverse_merge(baseline)
  end

  def to_s
    "#{id}: #{title}"
  end
end
