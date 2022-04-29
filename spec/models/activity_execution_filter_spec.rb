# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityExecutionFilter, type: :model do
  subject(:filter) { described_class.new(**params) }

  let(:activity) { create(:activity, participants_count_activity: 50) }
  let(:params) { {} }

  describe '#apply' do
    subject { filter.apply(ActivityExecution.all) }

    let!(:activity_executions) do
      create_list(:activity_execution, 3, activity: activity)
    end

    context 'with no params' do
      it { is_expected.to include(*activity_executions) }
    end

    context 'with field' do
      let(:field) { create(:field) }
      let(:params) { { field_id: field.id } }
      let!(:activity_executions_on_field) { create_list(:activity_execution, 2, activity: activity, field: field) }

      it { is_expected.to include(*activity_executions_on_field) }
    end
  end
end
