# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MidataService do
  let(:service) { described_class.new }
  let(:pbs_camp_unit_id) { '1328' }

  # describe '#pull_camp_unit', vcr: true do
  #   subject(:camp_unit) { service.pull_camp_unit(pbs_camp_unit_id) }

  #   it { is_expected.to have_attributes(pbs_id: pbs_camp_unit_id) }
  #   it { is_expected.to be_persisted }
  # end

  describe '#fetch_camp_unit_data', vcr: true do
    subject(:camp_unit_data) { service.fetch_camp_unit_data(pbs_camp_unit_id) }

    it { expect(camp_unit_data.dig('events', 0, 'id')).to eq(pbs_camp_unit_id) }
    it { expect(camp_unit_data.dig('events', 0, 'links', 'sub_camps')).to eq([1322, 1329]) }
  end

  describe '#fetch_participations', vcr: true do
    subject(:event_participations_data) { service.fetch_participations(group_id, event_id) }

    let(:group_id) { 749 }
    let(:event_id) { 1328 }

    it { expect(event_participations_data['current_page']).to eq 1 }
    it { expect(event_participations_data['event_participations'].length).to eq 2 }
  end
end
