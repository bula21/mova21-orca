# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/ExampleLength
RSpec.describe UnitParser do
  subject(:unit) { described_class.new(File.read(Rails.root.join(unit_json_path))).call }

  let(:unit_json_path) { 'spec/fixtures/unit.json' }

  it 'imports the right attributes for the unit' do
    expect(unit).to have_attributes(
      title: 'Sommerlager Pfadistufe',
      abteilung: 'H2O',
      kv: 1145,
      stufe: 'pfadi',
      expected_participants_f: 12,
      expected_participants_m: 10,
      expected_participants_leitung_m: 3,
      expected_participants_leitung_f: 5
    )
  end

  it 'is expected to have the right dates' do
    expect(unit.starts_at).to eq '2021-07-01 00:00:00.000000000 +0200'
    expect(unit.ends_at).to eq '2021-07-18 00:00:00.000000000 +0200'
  end

  context 'when is pta' do
    let(:unit_json_path) { 'spec/fixtures/unit_pta.json' }

    it 'imports the right attributes for the unit' do
      expect(unit).to have_attributes(
        title: 'Sommerlager PTA',
        abteilung: 'H2O',
        kv: 1145,
        stufe: 'pfadi',
        expected_participants_f: 3,
        expected_participants_m: 5,
        expected_participants_leitung_m: 4,
        expected_participants_leitung_f: 6
      )
    end
  end

  describe 'lagerleiter' do
    subject(:lagerleiter) { unit.lagerleiter }

    it 'imports the right attributes for the lagerleiter' do
      expect(lagerleiter).to have_attributes(
        pbs_id: 10,
        last_name: 'Newton',
        first_name: 'Azra',
        scout_name: 'Voluptate',
        email: 'newton_azra@hitobito.example.com',
        address: 'Sauerbruchstr. 42c',
        zip_code: '1125',
        town: 'Jaridorf',
        country: nil
      )
    end
  end

  describe 'al' do
    subject(:al) { unit.al }

    it 'imports the right attributes for the al' do
      expect(al).to have_attributes(
        pbs_id: 526,
        last_name: 'Daudrich',
        first_name: 'Mio',
        scout_name: 'Ut',
        email: 'daudrich_mio@hitobito.example.com',
        address: 'Alt Steinbücheler Weg 4',
        zip_code: '2233',
        town: 'Oppongburg',
        country: nil
      )
    end
  end

  context 'when al is the same as the lagerleiter' do
    let(:unit_json_path) { 'spec/fixtures/unit_same_leader_and_abteilungsleitung.json' }

    it 'creates only one leader and uses it for both' do
      expect { unit }.to change(Leader, :count).by(1)
    end
  end
end
# rubocop:enable RSpec/ExampleLength
