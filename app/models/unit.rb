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
#  calc_menu_token                 :string
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

# rubocop:disable Metrics/ClassLength
class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units, optional: true
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units
  belongs_to :coach, class_name: 'Leader', inverse_of: :coach_units, optional: true
  belongs_to :kv, inverse_of: :units, primary_key: :pbs_id

  has_many :invoices, inverse_of: :unit, dependent: :destroy
  has_many :unit_activities, -> { rank(:priority) }, inverse_of: :unit, dependent: :destroy
  has_many :participant_units, inverse_of: :unit, dependent: :destroy
  has_many :participants, -> { order(role: :asc, last_name: :asc, scout_name: :asc) },
           through: :participant_units, inverse_of: :units, dependent: :destroy
  has_many :unit_activity_executions, inverse_of: :unit, dependent: :destroy
  has_one :unit_visitor_day, inverse_of: :unit, dependent: :destroy
  has_many :unit_program_changes, inverse_of: :unit, dependent: :destroy

  has_many_attached :documents

  validates :title, presence: true, on: :complete
  validates :expected_participants, numericality: { greater_than_or_equal_to: 12 }, on: :complete
  validates :expected_participants_leitung, numericality: { greater_than_or_equal_to: 2 }, on: :complete
  validates :visitor_day_tickets, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate on: :complete do
    errors.add(:lagerleiter, :incomplete) unless lagerleiter.valid?(:complete)
  end

  def starts_at
    # Pfadis und Pios
    return self[:starts_at] if week_nr.blank?

    # PTA und Wölfe
    week_nr == 1 ? 1.day.after(Orca::CAMP_START) : 8.days.after(Orca::CAMP_START)
  end

  def ends_at
    # Pfadis und Pios
    return self[:ends_at] if week_nr.blank?

    # PTA und Wölfe
    week_nr == 1 ? 6.days.after(Orca::CAMP_START) : 1.day.ago(Orca::CAMP_END)
  end

  before_save :set_limesurvey_token
  after_create :notify_incomplete
  accepts_nested_attributes_for :participants
  accepts_nested_attributes_for :participant_units
  accepts_nested_attributes_for :lagerleiter
  accepts_nested_attributes_for :coach
  accepts_nested_attributes_for :al

  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en' }
  enum activity_booking_phase: { closed: 0, preview: 1, open: 2, committed: 3 }, _prefix: true

  delegate :locale, to: :kv

  def expected_participants
    (expected_participants_f || 0) + (expected_participants_m || 0) + (expected_guest_participants || 0)
  end

  def expected_participants_leitung
    (expected_participants_leitung_f || 0) + (expected_participants_leitung_m || 0) + (expected_guest_leaders || 0)
  end

  def expected_guests_total
    (expected_guest_participants || 0) + (expected_guest_leaders || 0)
  end

  def actual_participants
    participant_role_counts[:participant]
  end

  def currently_present?
    Time.zone.today.between?(starts_at, ends_at)
  end

  def week_nr
    # since this was hardcoded
    case week
    when /Erste|Première|Prima/
      1
    when /Zweite|Deuxième|Seconda/
      2
    end
  end

  def district_nr
    district&.scan(/\d*/)&.join('')&.to_i
  end

  def total_max_number_of_persons
    (definite_max_number_of_persons || 0) + total_internationals
  end

  def difference_in_total_to_allowed
    total_max_number_of_persons - participants.count
  end

  def total_internationals
    (expected_guest_participants || 0) + (expected_guest_leaders || 0)
  end

  def complete?
    valid?(:complete)
  end

  def shortened_title
    shortened = title.split(':').last.strip
    return shortened if shortened.length > 2

    title
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

  def cache_key
    [
      self.class,
      id, updated_at
    ].join('-')
  end
end
# rubocop:enable Metrics/ClassLength
