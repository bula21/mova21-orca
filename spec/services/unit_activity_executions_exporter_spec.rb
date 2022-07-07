# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivityExecutionsExporter, type: :service do
  subject(:exporter) { described_class.new(UnitActivityExecution.where(id: unit_activity_executions.map(&:id))) }

  let(:unit_activity_executions) { create_list(:unit_activity_execution, 30) }

  describe '#export' do
    subject(:csv) { exporter.export }

    it 'contains all unit_activity_executions' do
      expect(csv.scan("\n").size).to eq(1 + unit_activity_executions.size)
    end
  end

  describe '#filename' do
    subject { exporter.filename }

    it { is_expected.to start_with('unit_activity_execution') }
    it { is_expected.to end_with('.csv') }
  end
end
