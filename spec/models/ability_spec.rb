# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  let!(:units) { create_list(:unit, 3) }

  context 'when the user is not logged in' do
    let(:user) { nil }

    it { is_expected.not_to be_able_to(:read, units.first) }
  end

  context 'when user is logged in' do
    let(:user) { create(:user, pbs_id: 1234) }
    let(:pbs_id) { 1234 }
    let(:leader) { create(:leader, pbs_id: pbs_id) }
    let!(:unit_as_al) { create(:unit, al: leader) }
    let!(:unit_as_lagerleiter) { create(:unit, lagerleiter: leader) }
    let!(:unit_from_others) { create(:unit) }

    it { is_expected.to be_able_to(:read, unit_as_al) }
    it { is_expected.to be_able_to(:read, unit_as_lagerleiter) }
    it { is_expected.not_to be_able_to(:read, unit_from_others) }
  end
end
