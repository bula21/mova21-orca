# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  context 'when the user is not logged in' do
    before do
      create(:unit)
    end

    let(:user) { nil }

    it { is_expected.not_to be_able_to(:read, Unit.first) }
  end

  context 'when user is logged in' do
    context 'when is logged in via midata' do
      let(:user) { create(:user, pbs_id: 12_345) }
      let(:leader) { user.leader }

      let!(:unit_as_al) { create(:unit, al: leader) }
      let!(:unit_as_lagerleiter) { create(:unit, lagerleiter: leader) }
      let!(:unit_from_others) { create(:unit) }

      it { is_expected.to be_able_to(:read, unit_as_al) }
      it { is_expected.to be_able_to(:read, unit_as_lagerleiter) }
      it { is_expected.not_to be_able_to(:read, unit_from_others) }
      it { is_expected.not_to be_able_to(:export, Unit) }

      context 'when user is admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to be_able_to(:read, unit_as_al) }
        it { is_expected.to be_able_to(:read, unit_as_lagerleiter) }
        it { is_expected.to be_able_to(:read, unit_from_others) }
        it { is_expected.to be_able_to(:export, Unit) }
      end
    end

    context 'when user is logged in without midata id' do
      let(:user) { create(:user, pbs_id: nil) }
      let(:leader_without_midata) { user.leader }

      let!(:unit_as_lagerleiter) { create(:unit, lagerleiter: leader_without_midata) }
      let!(:other_unit) { create(:unit) }
      let!(:other_unit_without_al) { create(:unit, al: nil) }

      it { is_expected.to be_able_to(:read, unit_as_lagerleiter) }
      it { is_expected.not_to be_able_to(:read, other_unit) }
      it { is_expected.not_to be_able_to(:read, other_unit_without_al) }
    end
  end
end
