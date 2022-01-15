# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantUnitsFetcher, vcr: true do
  let(:unit) { build(:unit, pbs_id: event_id)}
  let(:service) { described_class.new(group_id, unit) }

  let(:unit_participants_size) { service.call.size }

  let(:group_id) { 749 }
  let(:event_id) { 1328 }

  it 'returns the event parcitipation data' do
    expect(unit_participants_size).to eq 2
  end

  context 'when there are no participations' do
    let(:group_id) { 3 }
    let(:event_id) { 1257 }

    it 'returns an empty array' do
      expect(unit_participants_size).to eq(0)
    end
  end

  context 'when there is more than one page' do
    let(:group_id) { 179 }
    let(:event_id) { 1322 }

    it 'merges the participants of all pages to the `event_participations`' do
      expect(unit_participants_size).to eq(51)
    end
  end
end
