# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  amount            :decimal(, )      default(0.0)
#  category          :integer          default("invoice")
#  invoice_address   :text
#  issued_at         :date
#  paid              :boolean          default(FALSE)
#  payable_until     :date
#  payment_info_type :string
#  ref               :string
#  sent_at           :datetime
#  text              :text
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  unit_id           :bigint           not null
#
# Indexes
#
#  index_invoices_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#
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
