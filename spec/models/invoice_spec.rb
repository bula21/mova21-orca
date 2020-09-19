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
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
