# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :unit, inverse_of: :invoices
  has_many :invoice_parts, dependent: :destroy, inverse_of: :invoice

  attribute :pdf

  enum category: %i[invoice pre_registration_invoice]

  before_save :generate_pdf
  after_create :set_ref
  after_touch :recalculate_amount

  def generate_pdf
    self.pdf = {
      io: StringIO.new(Pdf::InvoicePdf.new(self).render),
      filename: filename,
      content_type: 'application/pdf'
    }
  end

  def filename
    'Invoice.pdf'
  end

  def set_ref
    update(ref: EsrService.new.generate(self)) if ref.blank?
  end

  def recalculate_amount
    update(amount: invoice_parts.reduce(0) { |result, invoice_part| invoice_part.amount + result })
  end
end
