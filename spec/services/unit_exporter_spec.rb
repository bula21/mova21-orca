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

      context 'when no al is given' do
        let(:units) { build_list(:unit, 2, al: nil) }

        it 'contains all units' do
          expect(csv.scan("\n").size).to eq(1 + units.size)
        end
      end
    end
  end

  describe 'contains role counts' do
    subject(:participant_role_counts) { described_class.new([unit]).send(:participant_role_counts, unit) }

    let(:unit) { units.first }
    let(:role_counts) do
      {
        participant: rand(12.20),
        assistant_leader: rand(2..8),
        helper: rand(0..2),
        leader_mountain_security: rand(0..1),
        leader_snow_security: rand(0..1),
        leader_water_security: rand(0..1)
      }
    end

    before do
      role_counts.each { |role, count| count.times { create(:participant, role: role, units: [unit]) } }
    end

    it 'has the correct counts' do
      expect(participant_role_counts).to eq(role_counts)
    end
  end

  describe '#filename' do
    subject { described_class.new(units).filename }

    it { is_expected.to start_with('units-') }
    it { is_expected.to end_with('.csv') }
  end
end
