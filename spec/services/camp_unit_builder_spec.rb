# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampUnitBuilder do
  subject(:builder) { described_class.new(root_camp_unit) }

  let(:camp_unit_json_path) { 'spec/fixtures/unit.json' }
  let(:camp_unit_data) { JSON.parse(File.read(Rails.root.join(camp_unit_json_path))) }
  let(:root_camp_unit) { RootCampUnit.new(:pfadi, 1329) }

  describe '#from_data', vcr: true do
    subject(:camp_unit) { builder.from_data(camp_unit_data) }

    let(:starts_at) { Time.zone.parse('2021-07-01 00:00:00.000000000 +0200') }
    let(:ends_at) { Time.zone.parse('2021-07-18 00:00:00.000000000 +0200') }

    it 'has attributes' do
      expect(camp_unit).to have_attributes(
        title: 'Sommerlager Pfadistufe', abteilung: 'H2O', kv_id: 1145, stufe: 'pfadi',
        expected_participants_f: 12, expected_participants_m: 10,
        expected_participants_leitung_m: 3, expected_participants_leitung_f: 5,
        starts_at: starts_at, ends_at: ends_at
      )
    end

    describe 'lagerleiter' do
      subject(:lagerleiter) { camp_unit.lagerleiter }

      it 'has the leader' do
        expect(lagerleiter).to be_a(Leader)
        expect(lagerleiter).to be_valid
        expect(lagerleiter).to have_attributes(pbs_id: 10, last_name: 'Newton', first_name: 'Azra',
                                               scout_name: 'Voluptate', email: 'newton_azra@hitobito.example.com',
                                               address: 'Sauerbruchstr. 42c', zip_code: '1125', town: 'Jaridorf',
                                               country: nil)
      end
    end

    describe 'al' do
      subject(:al) { camp_unit.al }

      it 'has the al' do
        expect(al).to be_a(Leader)
        expect(al).to be_valid
        expect(al).to have_attributes(pbs_id: 526, last_name: 'Daudrich', first_name: 'Mio', scout_name: 'Ut',
                                      email: 'daudrich_mio@hitobito.example.com', address: 'Alt Steinbücheler Weg 4',
                                      zip_code: '2233', town: 'Oppongburg', country: nil)
      end
    end

    context 'when al is the same as the lagerleiter' do
      let(:camp_unit_json_path) { 'spec/fixtures/unit_same_leader_and_abteilungsleitung.json' }

      it 'creates only one leader and uses it for both' do
        expect { camp_unit }.to change(Leader, :count).by(1)
      end
    end

    context 'when is pta' do
      let(:camp_unit_json_path) { 'spec/fixtures/unit_pta.json' }
      let(:root_camp_unit) { RootCampUnit[:pta] }

      it 'imports the right attributes for the unit', skip: true do
        expect(camp_unit).to have_attributes(title: 'Sommerlager PTA', abteilung: 'H2O', kv_id: 1145, stufe: 'pta',
                                             expected_participants_f: 3, expected_participants_m: 5,
                                             expected_participants_leitung_m: 4, expected_participants_leitung_f: 6)
      end
    end
  end
end
