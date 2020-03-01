# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units, optional: true
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units
  # belongs_to :coach, class_name: 'Leader', inverse_of: :coach_units, optional: true

  validates :title, :kv, :lagerleiter, presence: true, on: :complete
  validates :expected_participants, numericality: { greater_than_or_equal_to: 12 }, on: :complete
  validates :expected_participants_leitung, numericality: { greater_than_or_equal_to: 2 }, on: :complete
  validate on: :complete do
    errors.add(:lagerleiter, :incomplete) unless lagerleiter.valid?(:complete)
  end

  before_create :set_limesurvey_token

  YEAR = 2021
  KVS = [
    166, # 'Pfadi St. Gallen - Appenzell',
    638, # 'AS Fribourgeois',
    1018, # 'AS Genevois',
    911, # 'AS Jurassienne',
    994, # 'AS Valaisan',
    3, # 'Pfadi Kanton Solothurn',
    4, # 'Pfadi Kanton Bern',
    85, # 'Pfadi Uri',
    142, # 'Pfadi Kanton Schwyz',
    161, # 'Pfadi Glarus',
    167, # 'Battasendas Grischun',
    4691, # 'Pfadi Aargau',
    631, # 'Pfadi Kanton Schaffhausen',
    237, # 'Pfadi Kanton Zug',
    179, # 'Pfadi Luzern',
    299, # 'Pfadi Region Basel',
    993, # 'Pfadi Thurgau',
    187, # 'Pfadi Unterwalden',
    238, # 'Scoutismo Ticino',
    880, # 'Scouts Neuchatelois',
    513, # 'Scouts Vaudois',
    1145 # ' Pfadi Zueri'
  ].freeze

  enum stufe: RootCampUnit.predefined.dup.transform_values(&:to_s)

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

  def limesurvey_url
    @limesurvey_url ||= LimesurveyService.new.url(token: limesurvey_token, lang: lagerleiter.language)
  end
end
