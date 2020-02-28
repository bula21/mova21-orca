# frozen_string_literal: true

class RootCampUnit
  attr_reader :root_id, :stufe
  delegate :to_s, :to_sym, to: :stufe

  def initialize(stufe, root_id)
    @stufe = stufe
    @root_id = root_id
  end

  def camp_unit_builder
    CampUnitBuilder.new(self)
  end

  def puller
    CampUnitPuller.new(self)
  end

  def self.predefined
    {
      wolf: new(:wolf, ENV['ROOT_CAMP_UNIT_ID_WOLF']),
      pfadi: new(:pfadi, ENV['ROOT_CAMP_UNIT_ID_PFADI']),
      pio: new(:pio, ENV['ROOT_CAMP_UNIT_ID_PIO']),
      pta: new(:pta, ENV['ROOT_CAMP_UNIT_ID_PTA'])
    }.freeze
  end

  def self.[](stufe)
    predefined[stufe]
  end
end
