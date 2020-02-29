# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units, optional: true
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units, optional: true
  # belongs_to :coach, class_name: 'Leader', inverse_of: :coach_units, optional: true
  validates :title, presence: true
  
  after_create :get_limesurvey_token

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

  def get_limesurvey_token
    return if self.limesurvey_token
    service = LimesurveyService.new
    service.add_leader(self.lagerleiter, self, ENV['LIMESURVEY_SURVEY_ID'], extract_language)
  end

  private

  def extract_language
    fr = [638, 1018, 911, 994, 513, 880]
    it = [238]
    if it.include? kv
      'it-informal'
    elsif fr.include? kv
      'fr'
    else
      'de-informal'
    end
  end
end
