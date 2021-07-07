# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivity, type: :model do
  describe 'priority' do
    subject(:prioritized) { unit.unit_activities.prioritized }

    let(:unit) { create(:unit) }
    let!(:unit_activities) do
      [
        create(:unit_activity, unit: unit, priority_position: 1),
        create(:unit_activity, unit: unit, priority_position: :last),
        create(:unit_activity, unit: unit, priority_position: :first)
      ]
    end

    it 'is ordered correctly' do
      expect(prioritized.pluck(:id)).to eq([unit_activities[2].id, unit_activities[0].id, unit_activities[1].id])
    end
  end
end
