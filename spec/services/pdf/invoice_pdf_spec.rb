# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdf::InvoicePdf do
  subject(:inspector) { PDF::Inspector::Text.analyze(rendered) }

  let(:invoice) { create(:invoice, :with_invoice_parts) }
  let(:pdf) { described_class.new(invoice) }

  let(:rendered) { pdf.render }

  it { expect(inspector.strings.join(' ')).to include(invoice.unit.title, format('%.2f', invoice.amount)) }

  it do
    File.open(Rails.root.join('tmp/invoice.pdf'), 'wb') do |file|
      file.write(pdf.render)
    end
  end
end
