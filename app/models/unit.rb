# frozen_string_literal: true

class Unit < ApplicationRecord
  belongs_to :al, class_name: 'Leader', inverse_of: :al_units
  belongs_to :lagerleiter, class_name: 'Leader', inverse_of: :lagerleiter_units

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

  enum stufe: {
    wolf: 'wolf',
    pfadi: 'pfadi',
    pio: 'pio',
    rover: 'rover'
  }

  validates :title, presence: true
end
