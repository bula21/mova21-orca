# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :unit, inverse_of: :invoices
  has_many :invoice_parts, dependent: :destroy, inverse_of: :invoice
  has_one_attached :pdf

  enum category: { invoice: 0, pre_registration_invoice: 1 }

  validates :category, :unit, presence: true

  before_save :recalculate_amount
  before_update :generate_pdf
  after_save :set_ref
  after_create do
    set_ref
    generate_pdf && save
  end

  def generate_pdf
    self.pdf = {
      io: StringIO.new(Pdf::InvoicePdf.new(self).render),
      filename: filename,
      content_type: 'application/pdf'
    }
  end

  def filename
    "#{[category, unit_id, ref].join('-')}.pdf"
  end

  def set_ref
    update(ref: EsrService.new.generate(self)) if ref.blank?
  end

  def recalculate_amount
    self.amount = invoice_parts.sum(&:amount)
  end
end
