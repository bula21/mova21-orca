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
end
