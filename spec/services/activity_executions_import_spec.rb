# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityExecutionsImport do
  subject(:import_service) { described_class.new(file, activity) }

  let(:activity) { create(:activity, participants_count_activity: 10) }
  let(:file) do
    Rack::Test::UploadedFile.new(Rails.root.join(filename),
                                 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end

  before do
    spot = create(:spot, name: 'Lagerplatz')
    create(:field, name: 'Feld 1', spot: spot)
    create(:activity_execution, activity: activity, amount_participants: 10)
  end

  context 'when is valid' do
    let(:filename) { 'spec/support/data/valid_sample_import_activity_executions.xlsx' }

    it 'imports the data' do
      expect { import_service.call }.to change(ActivityExecution, :count).from(1).to(3)
      expect(import_service.errors).to be_empty
    end
  end

  context 'when has invalid rows' do
    let(:filename) { 'spec/support/data/invalid_sample_import_activity_executions.xlsx' }

    it 'imports the data' do
      expect { import_service.call }.not_to change(ActivityExecution, :count)
      expect(import_service.errors).to eq ['Row 2: Anzahl TN muss kleiner oder gleich 10 sein']
    end
  end

  context 'when has invalid type' do
    let(:filename) { 'spec/fixtures/sample.pdf' }

    it 'imports the data' do
      expect { import_service.call }.to raise_error(TypeError)
    end
  end
end
