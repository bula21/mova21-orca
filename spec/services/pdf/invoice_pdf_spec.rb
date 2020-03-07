# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdf::InvoicePdf do
  let(:invoice) { create(:invoice) }
  let(:pdf) { described_class.new(invoice) }

  subject(:rendered) { pdf.render }
  subject(:inspector) { PDF::Inspector::Text.analyze(rendered) }

  it { expect(inspector.strings.join).to include("Hello") }
  it do
    File.open("/app/tmp/invoice.pdf", "wb") do |file|
      file.write(pdf.render)
    end
  end

end
