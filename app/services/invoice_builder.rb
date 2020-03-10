# frozen_string_literal: true

class InvoiceBuilder
  def pre_registration_invoice_for_camp_unit(camp_unit)
    return if camp_unit.invoices.pre_registration_invoice.exists?

    I18n.with_locale(camp_unit.kv.locale) do
      camp_unit.invoices.create(category: :pre_registration_invoice) do |invoice|
        invoice.invoice_parts = pre_registration_invoice_parts(camp_unit)
      end
    end
  end

  def pre_registration_invoice_parts(camp_unit)
    price_per_participant = camp_unit.root_camp_unit.pre_registration_price
    [
      pre_registration_participants_invoice_part(camp_unit.expected_participants, price_per_participant),
      pre_registration_participants_invoice_part(camp_unit.expected_participants_leitung, price_per_participant)
    ]
  end

  def pre_registration_participants_invoice_part(participants, price_per_participant)
    i18n_scope = 'invoices.pre_registration_invoice.participants_invoice_parts'

    InvoicePart.new(
      amount: price_per_participant * participants, label: I18n.t('label', scope: i18n_scope),
      breakdown: I18n.t('breakdown', scope: i18n_scope,
                                     price_per_participant: price_per_participant,
                                     participants: participants)
    )
  end
end
