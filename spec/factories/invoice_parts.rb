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
FactoryBot.define do
  factory :invoice_part do
    invoice { nil }
    type { '' }
    amount { '9.99' }
    label { 'MyString' }
    breakdown { 'MyString' }
    ordinal { 1 }
  end
end
