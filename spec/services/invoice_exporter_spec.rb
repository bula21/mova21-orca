# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceExporter, type: :service do
  let(:invoices) { create_list(:invoice, 2) }

  describe '#export' do
    subject(:csv) { described_class.new(invoices).export }

    let(:invoice) { invoices.first }

    it 'contains all invoices' do
      expect(csv.scan("\n").size).to eq(1 + invoices.size)
    end

    describe 'contains all invoices values' do
      it { is_expected.to include invoice.ref }
      it { is_expected.to include invoice.unit.id.to_s }
      it { is_expected.to include invoice.unit.lagerleiter.full_name }
      it { is_expected.to include invoice.id.to_s }
      it { is_expected.to include invoice.amount.to_s }
    end
  end
end
