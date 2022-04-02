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
FactoryBot.define do
  factory :invoice do
    unit
    ref { Faker::Bank.iban }
    issued_at { 1.week.ago }
    payable_until { 3.months.from_now }
    text { Faker::Lorem.sentences }
    category { :pre_registration_invoice }
    generated { true }
  end

  trait :with_invoice_parts do
    after(:build) do |invoice|
      invoice.invoice_parts = build_list(:invoice_part, 3, invoice: invoice)
    end
  end
end
