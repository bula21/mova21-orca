# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitParser do
  describe '#call' do
    it 'parses fixture' do
      result = described_class.new(File.read(Rails.root.join('spec', 'fixtures', 'unit.json'))).call
      expect(result.title).to eq 'Sommerlager Pfadistufe'
      expect(result.abteilung).to eq 'H2O'
      expect(result.kv).to eq 1145
      expect(result.stufe).to eq 'pfadi'
      expect(result.expected_participants_f).to eq 12
      expect(result.expected_participants_m).to eq 10
      expect(result.expected_participants_leitung_m).to eq 3
      expect(result.expected_participants_leitung_f).to eq 5
      expect(result.starts_at).to eq '2021-07-01T00:00:00.000+02:00'
      expect(result.ends_at).to eq '2021-07-18T00:00:00.000+02:00'
    end

    xit 'parses pta' do
      result = described_class.new(File.read(Rails.root.join('spec', 'fixtures', 'unit_pta.json'))).call
      pp result
      expect(result.title).to eq 'Sommerlager PTA'
      expect(result.expected_participants_f).to eq 11
      expect(result.expected_participants_m).to eq 14
      expect(result.expected_participants_leitung_m).to eq 4
      expect(result.expected_participants_leitung_f).to eq 6
    end
  end
end
