# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :unit, inverse_of: :invoices
  has_many :invoice_parts, dependent: :destroy, inverse_of: :invoice


  def generate_pdf
    self.pdf = {
      io: StringIO.new(Pdf::InvoicePdf.new(self).render),
      filename: filename,
      content_type: 'application/pdf'
    }
  end

  def filename
    "Test.pdf"
  end
end
