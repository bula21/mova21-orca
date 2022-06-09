# frozen_string_literal: true

# == Schema Information
#
# Table name: units
#
#  id                              :bigint           not null, primary key
#  abteilung                       :string
#  district                        :string
#  ends_at                         :datetime
#  expected_participants_f         :integer
#  expected_participants_leitung_f :integer
#  expected_participants_leitung_m :integer
#  expected_participants_m         :integer
#  language                        :string
#  limesurvey_token                :string
#  midata_data                     :jsonb
#  starts_at                       :datetime
#  stufe                           :string
#  title                           :string
#  week                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  al_id                           :bigint
#  coach_id                        :bigint
#  kv_id                           :integer
#  lagerleiter_id                  :bigint           not null
#  pbs_id                          :integer
#
# Indexes
#
#  index_units_on_al_id           (al_id)
#  index_units_on_coach_id        (coach_id)
#  index_units_on_lagerleiter_id  (lagerleiter_id)
#
# Foreign Keys
#
#  fk_rails_...  (al_id => leaders.id)
#  fk_rails_...  (coach_id => leaders.id)
#  fk_rails_...  (lagerleiter_id => leaders.id)
#
require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build(:unit) }

  describe 'complete?' do
    subject { unit.complete? }

    it { is_expected.to be true }

    context 'when is not complete' do
      let(:unit) { build(:unit, kv_id: nil) }

      it { is_expected.to be false }
    end
  end

  describe 'starts_at and ends_at' do
    let(:unit) { build(:unit, stufe: stufe, starts_at: Orca::CAMP_START, ends_at: Orca::CAMP_END, week: week) }
    let(:week) { nil }

    context 'when is pfadi' do
      let(:stufe) { Stufe.find_by(code: 'pfadi') }

      it 'uses the beginning of the camp as start date' do
        expect(unit.starts_at.to_date).to eq Date.new(2022, 7, 23)
        expect(unit.ends_at.to_date).to eq Date.new(2022, 8, 6)
      end
    end

    %w[wolf pta].each do |stufe_code|
      context "when is #{stufe_code}" do
        let(:stufe) { Stufe.find_by(code: stufe_code) }

        context 'when is first week' do
          let(:week) { 'Erste Lagerwoche' }

          it 'uses the beginning of the camp as start date' do
            expect(unit.starts_at.to_date.to_s).to eq Date.new(2022, 7, 24).to_s
            expect(unit.ends_at.to_date.to_s).to eq Date.new(2022, 7, 29).to_s
          end
        end

        context 'when is second week' do
          let(:week) { 'Zweite Lagerwoche' }

          it 'uses the beginning of the camp as start date' do
            expect(unit.starts_at.to_date.to_s).to eq Date.new(2022, 7, 31).to_s
            expect(unit.ends_at.to_date.to_s).to eq Date.new(2022, 8, 5).to_s
          end
        end
      end
    end

    context 'when is pta' do
      let(:stufe) { Stufe.find_by(code: 'pta') }

      it 'uses the beginning of the camp as start date' do
        expect(unit.starts_at.to_date).to eq Date.new(2022, 7, 23)
        expect(unit.ends_at.to_date).to eq Date.new(2022, 8, 6)
      end
    end
  end

  describe 'contains role counts' do
    subject(:participant_role_counts) { unit.participant_role_counts }

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
      unit.save
      role_counts.each do |role, count|
        count.times { unit.participant_units.create!(participant: create(:participant), role: role) }
      end
    end

    it 'has the correct counts' do
      expect(participant_role_counts).to eq(role_counts)
    end
  end

  describe '#shortened_title' do
    subject { unit.shortened_title }

    let(:unit) do
      build(:unit,
            title: 'mova - Wolfsstufe / branche Louveteaux / branca lupetti: Pfadicorps Tick Trick Track und Donald')
    end

    it { is_expected.to eq 'Pfadicorps Tick Trick Track und Donald' }

    context 'when has no mova - starting' do
      let(:unit) { build(:unit, title: 'The fancy group') }

      it { is_expected.to eq 'The fancy group' }
    end
  end
end
