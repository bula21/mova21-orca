# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivityExecutionFilter, type: :model do
  subject(:filter) { described_class.new(**params) }

  let(:params) { {} }

  describe '#apply' do
    subject { filter.apply(UnitActivityExecution.all) }

    let!(:unit_activity_executions) do
      create_list(:unit_activity_execution, 3)
    end

    context 'with no params' do
      it { is_expected.to include(*unit_activity_executions) }
    end

    context 'with id' do
      let(:ids) { "test,#{unit_activity_executions.first.id},error" }
      let(:params) { { id: ids } }

      it { is_expected.to contain_exactly(unit_activity_executions.first) }
    end
  end
end
