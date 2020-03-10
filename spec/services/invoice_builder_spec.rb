# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceBuilder do
  subject(:builder) { described_class.new }

  let(:camp_unit) { create(:camp_unit, stufe: :pfadi) }

  describe '#pre_registration_invoice_for_camp_unit' do
    subject(:invoice) { builder.pre_registration_invoice_for_camp_unit(camp_unit) }

    let(:invoiced_participants) { camp_unit.expected_participants + camp_unit.expected_participants_leitung }

    it { is_expected.to be_pre_registration_invoice }
    it { is_expected.to have_attributes(amount: invoiced_participants * 15.0) }
    it { expect(invoice.invoice_parts.count).to be(2) }
  end
end
