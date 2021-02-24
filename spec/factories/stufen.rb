# frozen_string_literal: true

# == Schema Information
#
# Table name: stufen
#
#  id         :bigint           not null, primary key
#  name       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :stufe do
    name { 'Wolf' }
  end
end
