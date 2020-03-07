# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdf::InvoicePdf do
  let(:invoice) { create(:invoice) }
  let(:pdf) { described_class.new(invoice) }

  subject(:inspector) { PDF::Inspector::Text.analyze(pdf.render) }

  it { expect(inspector.strings.join).to include("Hello") }
end
