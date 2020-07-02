# frozen_string_literal: true

class RootCampUnit
  attr_reader :root_id, :stufe, :pre_registration_price
  delegate :to_s, :to_sym, to: :stufe

  def initialize(stufe, root_id, pre_registration_price: 0)
    @stufe = stufe
    @root_id = root_id
    @pre_registration_price = pre_registration_price
  end

  def camp_unit_builder
    CampUnitBuilder.new(self)
  end

  def puller
    CampUnitPuller.new(self)
  end

  def self.predefined
    {
      wolf: new(:wolf, ENV['ROOT_CAMP_UNIT_ID_WOLF'], pre_registration_price: 10.0),
      pfadi: new(:pfadi, ENV['ROOT_CAMP_UNIT_ID_PFADI'], pre_registration_price: 15.0),
      pio: new(:pio, ENV['ROOT_CAMP_UNIT_ID_PIO'], pre_registration_price: 15.0),
      pta: new(:pta, ENV['ROOT_CAMP_UNIT_ID_PTA'], pre_registration_price: 10.0)
    }.freeze
  end

  def self.[](stufe)
    predefined[stufe]
  end
end
