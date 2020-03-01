# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampUnitPuller do
  subject(:puller) { described_class.new(root_camp_unit) }

  let(:root_camp_unit) { RootCampUnit[:pfadi] }

  describe '#pull_all', vcr: true do
    subject(:camp_units) { puller.pull_all }

    it do
      expect(camp_units.count).to be 2
      expect(camp_units).to all(be_valid)
    end
  end

  describe '#pull_new', vcr: true do
    subject(:new_camp_units) { puller.pull_new }

    it do
      expect(new_camp_units.count).to be 1
      expect(new_camp_units).to all(be_valid)
    end

    it 'does not pull again' do
      expect(new_camp_units.count).to be_positive
      expect(puller.pull_new.compact).to eq([])
    end
  end
end
