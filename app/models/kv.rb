# frozen_string_literal: true

class Kv
  attr_reader :pbs_id, :name, :locale

  def initialize(name, pbs_id, locale: :de)
    @name = name
    @pbs_id = pbs_id
    @locale = locale
  end

  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def self.predefined
    [
      new(166, 'Pfadi St. Gallen - Appenzell', locale: :de),
      new(638, 'AS Fribourgeois', locale: :fr),
      new(1018, 'AS Genevois', locale: :fr),
      new(911, 'AS Jurassienne', locale: :fr),
      new(994, 'AS Valaisan', locale: :fr),
      new(3, 'Pfadi Kanton Solothurn', locale: :de),
      new(4, 'Pfadi Kanton Bern', locale: :de),
      new(85, 'Pfadi Uri', locale: :de),
      new(142, 'Pfadi Kanton Schwyz', locale: :de),
      new(161, 'Pfadi Glarus', locale: :de),
      new(167, 'Battasendas Grischun', locale: :de),
      new(4691, 'Pfadi Aargau', locale: :de),
      new(631, 'Pfadi Kanton Schaffhausen', locale: :de),
      new(237, 'Pfadi Kanton Zug', locale: :de),
      new(179, 'Pfadi Luzern', locale: :de),
      new(299, 'Pfadi Region Basel', locale: :de),
      new(993, 'Pfadi Thurgau', locale: :de),
      new(187, 'Pfadi Unterwalden', locale: :de),
      new(238, 'Scoutismo Ticino', locale: :it),
      new(880, 'Scouts Neuchatelois', locale: :fr),
      new(513, 'Scouts Vaudois', locale: :fr),
      new(1145, 'Pfadi Zueri', locale: :de)
    ].freeze
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def self.[](id)
    predefined.find { |kv| kv.pbs_id == id }
  end
end
