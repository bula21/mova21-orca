# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }
  let!(:units) { create_list(:unit, 3) }

  context 'when the user is not logged in' do
    let(:user) { nil }

    it 'can not see any units' do
      is_expected.not_to be_able_to(:read, units.first)
    end
  end

  context 'when user is logged in' do
    let!(:user) { create(:user, pbs_id: 1234) }
    let(:pbs_id) { 1234 }
    let(:leader) { create(:leader, pbs_id: pbs_id) }
    let(:unit_as_al) { create(:unit, al: leader) }
    let(:unit_as_lagerleiter) { create(:unit, lagerleiter: leader) }
    let(:unit_from_others) { create(:unit) }
    let!(:units) { [unit_as_al, unit_as_lagerleiter, unit_from_others] }

    it 'can see his units' do
      is_expected.to be_able_to(:read, units.first)
      is_expected.to be_able_to(:read, units.second)
      is_expected.not_to be_able_to(:read, units.third)
    end

  end
end
