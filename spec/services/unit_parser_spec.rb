# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitParser do
  subject(:unit) { described_class.new(File.read(Rails.root.join('spec', 'fixtures', 'unit.json'))).call }

  it do
    is_expected.to have_attributes(
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
    expect(subject.starts_at).to eq '2021-07-01 00:00:00.000000000 +0200'
    expect(subject.ends_at).to eq '2021-07-18 00:00:00.000000000 +0200'
  end

  # TODO: Fix spec
  xit 'parses pta' do
    result = described_class.new(File.read(Rails.root.join('spec', 'fixtures', 'unit_pta.json'))).call
    pp result
    expect(result.title).to eq 'Sommerlager PTA'
    expect(result.expected_participants_f).to eq 11
    expect(result.expected_participants_m).to eq 14
    expect(result.expected_participants_leitung_m).to eq 4
    expect(result.expected_participants_leitung_f).to eq 6
  end

  describe 'lagerleiter' do
    subject(:lagerleiter) { unit.lagerleiter }

    it do
      is_expected.to have_attributes(
                         pbs_id: 10,
                         last_name: 'Newton',
                         first_name: 'Azra',
                         scout_name: 'Voluptate',
                         email: 'newton_azra@hitobito.example.com'
                     )
    end
  end

  describe 'al' do
    subject(:al) { unit.al }

    it do
      is_expected.to have_attributes(
                         pbs_id: 526,
                         last_name: 'Daudrich',
                         first_name: 'Mio',
                         scout_name: 'Ut',
                         email: 'daudrich_mio@hitobito.example.com'
                     )
    end
  end
end
