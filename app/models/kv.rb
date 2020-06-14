# frozen_string_literal: true

class Kv
  attr_reader :pbs_id, :name, :locale

  def initialize(pbs_id, name, locale: :de)
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
    return predefined.find { |kv| kv.pbs_id == id } if midata_test_environment?

    predefined_development.find { |kv| kv.pbs_id == id }
  end

  def self.predefined_development
    [
        new(234, "AS Genevois", locale: :fr),
        new(397, "AS Jurassienne", locale: :fr),
        new(391, "AS Valaisan", locale: :fr),
        new(57, "Battasendas Grischun", locale: :de),
        new(400, "Pfadi Aargau", locale: :de),
        new(425, "Pfadi Glarus", locale: :de),
        new(2, "Pfadi Kanton Bern", locale: :de),
        new(49, "Pfadi Kanton Luzern", locale: :de),
        new(426, "Pfadi Kanton Schwyz", locale: :de),
        new(428, "Pfadi Kanton Solothurn", locale: :de),
        new(424, "Pfadi Kanton Zug", locale: :de),
        new(205, "Pfadi Kantonalverband Schaffhausen", locale: :de),
        new(429, "Pfadi Region Basel", locale: :de),
        new(64, "Pfadi St. Gallen – Appenzell", locale: :de),
        new(80, "Pfadi Thurgau", locale: :de),
        new(166, "Pfadi Unterwalden", locale: :de),
        new(427, "Pfadi Uri", locale: :de),
        new(3, "Pfadi Züri", locale: :de),
        new(423, "Scoutismo Ticino", locale: :it),
        new(70, "Scouts Fribourgeois", locale: :de),
        new(156, "Scouts Neuchâtelois", locale: :fr),
        new(4, "Scouts Vaudois", locale: :fr)
    ]
  end

  private

  def self.midata_test_environment?
    ENV['MIDATA_BASE_URL'].include? 'pbs.puzzle.ch'
  end
end
