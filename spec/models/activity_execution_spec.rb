# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityExecution, type: :model do
  let(:activity) { create(:activity, participants_count_activity: 50) }
  let(:activity_execution) { create(:activity_execution, activity: activity) }

  describe '#headcount' do
    subject(:headcount) { activity_execution.headcount }

    before do
      create_list(:unit_activity_execution, 4, activity_execution: activity_execution, headcount: 10)
    end

    it { is_expected.to be 40 }
    it { expect(activity_execution.available_headcount).to be 10 }
  end
end
