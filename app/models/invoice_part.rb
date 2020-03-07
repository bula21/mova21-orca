# frozen_string_literal: true

class InvoicePart < ApplicationRecord
  belongs_to :invoice

  after_save do
    invoice.recalculate_amount
  end

  before_validation do
    self.amount = amount.floor(2)
  end
end
