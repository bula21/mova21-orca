# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitProgramChange, type: :model do
  describe UnitActivityExecution do
    let(:unit_activity_execution) { create(:unit_activity_execution) }

    it 'tracks the changes in new UnitProgramChange record' do
      unit_activity_execution.update!(track_changes_enabled: true, change_remarks: 'Test', change_notification: true)
      expect(unit_activity_execution.unit_program_changes.count).to eq(1)

      change = unit_activity_execution.unit_program_changes.last
      expect(change.remarks).to eq('Test')
      expect(change.notified_at).not_to be_nil
      expect(change.unit).to eq(unit_activity_execution.unit)
      expect(change.activity_execution).to eq(unit_activity_execution.activity_execution)
    end
  end

  describe ActivityExecution do
    let(:activity_execution) { create(:activity_execution) }
    let(:unit_activity_executions) { create_list(:unit_activity_execution, 3, activity_execution: activity_execution) }

    it 'tracks the changes in new UnitProgramChange record' do
      unit_activity_executions
      activity_execution.reload
      activity_execution.update!(track_changes_enabled: true, change_remarks: 'Test', change_notification: true)
      expect(activity_execution.unit_program_changes.count).to eq(3)

      change = activity_execution.unit_program_changes.last
      expect(change.remarks).to eq('Test')
      expect(change.notified_at).not_to be_nil
      expect(change.unit).not_to be_nil
      expect(change.activity_execution).to eq(activity_execution)
    end
  end
end
