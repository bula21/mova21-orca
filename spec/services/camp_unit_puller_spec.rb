# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampUnitPuller do
  # If you have to update the VCR cassettes you can follow these steps:
  #  * use Postman to create a OAUTH-Token and add the infos from https://pbs.puzzle.ch/de/oauth/applications/36
  #  * generate an access-token and copy it to MIDATA_OAUTH_ACCESS_TOKEN
  subject(:puller) { described_class.new(stufe) }

  include_context 'with base data'

  let(:stufe) { build(:stufe, code: :pfadi, root_camp_unit_id: 1328) }

  describe '#pull_all', vcr: true, record: :once do
    subject(:camp_units) { puller.pull_all }

    it do
      expect(camp_units.count).to be 2
      expect(camp_units).to all(be_valid)
      expect(Leader.count).to be 6
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

      context 'when some participants have been changed in midata' do
        let(:updated_participant) { camp_units.first.participants.first }

        before do
          updated_participant.update(first_name: 'Barbaraa')
        end

        it 'updates them locally to the status of the midata' do
          expect { puller.pull_all }.to change { updated_participant.reload.first_name }.from('Barbaraa').to('Barbara')
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

  describe '#pull_new', vcr: true, record: :once do
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

  describe '#pull', vcr: false do
    subject(:pull) { puller.pull(pbs_id: 223) }

    let(:unit_data) { JSON.parse(File.read(Rails.root.join('spec/fixtures/unit.json'))) }
    let(:unit_data_updated) { JSON.parse(File.read(Rails.root.join('spec/fixtures/unit_updated.json'))) }
    let(:participants) { JSON.parse(File.read(Rails.root.join('spec/fixtures/participations_empty.json'))) }
    let(:mock_midata_service) { instance_double(MidataService) }

    before do
      allow(MidataService).to receive(:new).and_return(mock_midata_service)
      allow(mock_midata_service).to receive(:fetch_camp_unit_data)
        .with('/events/223.json')
        .and_return(unit_data, unit_data_updated)
      allow(mock_midata_service).to receive(:fetch_participations).with('2', 223).and_return(participants)
      puller.pull(pbs_id: 223)
    end

    it 'updates the lagerleiter' do
      expect { pull }.to change { Unit.find_by(pbs_id: 223).lagerleiter.pbs_id }.from(10).to(15)
    end

    context 'when the new data is invalid' do
      let(:unit_data_updated) do
        JSON.parse(File.read(Rails.root.join('spec/fixtures/unit_updated.json'))).tap do |data|
          data['linked']['people'][1]['email'] = ''
        end
      end

      it 'shows a proper error' do
        allow(Rails.logger).to receive(:error)
        pull
        expect(Rails.logger).to have_received(:error)
          .with(a_string_matching('Lagerleiter email muss ausgefüllt werden'))
          .at_least(:once)
      end
    end
  end
end
