FactoryBot.define do
  factory :invoice_part do
    invoice { nil }
    type { "" }
    amount { "9.99" }
    label { "MyString" }
    breakdown { "MyString" }
    ordinal { 1 }
  end
end
