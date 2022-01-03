# frozen_string_literal: true

class InvoiceBuilder
  include ActionView::Helpers::NumberHelper

  def pre_registration_invoice_for_camp_unit(camp_unit, locale = camp_unit.language)
    I18n.with_locale(locale) do
      camp_unit.invoices.find_or_initialize_by(category: :pre_registration_invoice).tap do |invoice|
        invoice.invoice_parts = pre_registration_invoice_parts(camp_unit)
        invoice.invoice_address = invoice_address_lines(camp_unit)
        invoice.save
      end
    end
  end

  def pre_registration_invoice_parts(camp_unit)
    # price_per_participant = camp_unit.stufe.pre_registration_price
    price_per_participant = 0
    [
      pre_registration_invoice_part(camp_unit.expected_participants, price_per_participant, camp_unit.stufe),
      pre_registration_invoice_part(camp_unit.expected_participants_leitung, price_per_participant, :leitung)
    ]
  end

  def pre_registration_invoice_part(participants, price_per_participant, stufe)
    i18n_scope = 'invoices.pre_registration_invoice.invoice_parts'

    InvoicePart.new(
      amount: price_per_participant * participants,
      label: I18n.t(stufe, scope: "#{i18n_scope}.label"),
      breakdown: I18n.t('breakdown', scope: i18n_scope,
                                     price_per_participant: number_to_currency(price_per_participant, unit: 'CHF'),
                                     participants: participants)
    )
  end

  def invoice_address_lines(camp_unit)
    camp_unit.lagerleiter&.address_lines
  end
end
