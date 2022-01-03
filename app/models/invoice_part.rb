# frozen_string_literal: true

# == Schema Information
#
# Table name: invoice_parts
#
#  id         :bigint           not null, primary key
#  amount     :decimal(, )
#  breakdown  :string
#  label      :string
#  ordinal    :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  invoice_id :bigint           not null
#
# Indexes
#
#  index_invoice_parts_on_invoice_id  (invoice_id)
#
# Foreign Keys
#
#  fk_rails_...  (invoice_id => invoices.id)
#
class InvoicePart < ApplicationRecord
  belongs_to :invoice

  after_save do
    invoice.recalculate_amount
  end

  before_validation do
    self.amount = amount.floor(2)
  end
end
