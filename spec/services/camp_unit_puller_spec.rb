# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampUnitPuller do
  subject(:puller) { described_class.new(root_camp_unit) }

  include_context 'with base data'

  let(:root_camp_unit) { RootCampUnit.new(:pfadi, 1328) }

  describe '#pull_all', vcr: true do
    subject(:camp_units) { puller.pull_all }

    it do
      expect(camp_units.count).to be 2
      expect(camp_units).to all(be_valid)
    end

    it 'imports the participants correctly' do
      expect(camp_units.first.participants.count).to be 51
      expect(camp_units.second.participants.count).to be 2
    end

    context 'when pulls later' do
      before do
        puller.pull_all
      end

      it 'does not change the participants ids' do
        expect { puller.pull_all }.not_to(change { Unit.first.participants.reload.ids })
      end

      context 'when some participants have been deleted' do
        let!(:only_local_participant) { create(:participant, units: [Unit.second]) }

        it 'removes the participants that are no longer on MiData from the unit, but keeps them' do
          expect { puller.pull_all }.to change { Unit.second.participants.reload.size }.from(3).to(2)
          expect(Participant.find(only_local_participant.id)).to eq(only_local_participant)
        end
      end

      context 'when there is a manual participant in the unit' do
        let(:non_midata_user) { create(:participant, :non_midata, units: [Unit.second]) }

        it 'obtains the user' do
          expect { puller.pull_all }.not_to(change { non_midata_user.units.reload.size })
        end
      end
    end
  end

  describe '#pull_new', vcr: true, record: :all do
    subject(:new_camp_units) { puller.pull_new }

    it do
      expect(new_camp_units.count).to be 2
      expect(new_camp_units).to all(be_valid)
    end

    it 'does not pull again' do
      expect(new_camp_units.count).to be_positive
      expect(puller.pull_new.compact).to eq([])
    end
  end
end
