# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitExporter, type: :service do
  let(:units) { build_list(:unit, 2) }

  describe '#export' do
    subject(:csv) { described_class.new(units).export }

    it 'contains all units' do
      expect(csv.scan("\n").size).to eq(1 + units.size)
    end

    describe 'contains all units values' do
      it { is_expected.to include units.first.title }
      it { is_expected.to include units.second.title }

      it { is_expected.to include units.first.lagerleiter.scout_name }
      it { is_expected.to include units.second.lagerleiter.scout_name }
    end
  end

  describe '#filename' do
    subject { described_class.new(units).filename }

    it { is_expected.to start_with('units-') }
    it { is_expected.to end_with('.csv') }
  end
end
