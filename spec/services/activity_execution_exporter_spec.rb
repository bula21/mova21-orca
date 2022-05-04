# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityExecutionExporter, type: :service do
  let(:activity_executions) { build_list(:activity_execution, 3) }

  describe '#export' do
    subject(:csv) { described_class.new(activity_executions).export }

    it 'contains all units' do
      expect(csv.scan("\n").size).to eq(1 + activity_executions.size)
    end
  end

  describe '#filename' do
    subject { described_class.new(activity_executions).filename }

    it { is_expected.to start_with('activity_execution') }
    it { is_expected.to end_with('.csv') }
  end
end
