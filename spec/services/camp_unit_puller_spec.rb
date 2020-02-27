# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampUnitPuller do
  subject(:puller) { described_class.new(root_camp_unit) }

  let(:root_camp_unit) { Unit::ROOT_CAMP_UNITS[:pfadi] }

  describe '#pull_camp_unit_hierarchy', vcr: true do
    subject(:camp_units) { puller.pull_camp_unit_hierarchy }

    it do
      expect(camp_units.count).to be 2
      expect(camp_units).to all(be_valid)
    end
  end

  describe '#pull_new_camp_units_from_camp_unit_hierarchy', vcr: true do
    subject(:new_camp_units) { puller.pull_new_camp_units_from_camp_unit_hierarchy }

    it do
      expect(new_camp_units.count).to be 1
      expect(new_camp_units).to all(be_valid)
    end

    it 'does not pull again' do
      expect(new_camp_units.count).to be_positive
      expect(puller.pull_new_camp_units_from_camp_unit_hierarchy).to eq([])
    end
  end
end
