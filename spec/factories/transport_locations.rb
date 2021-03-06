# frozen_string_literal: true

# == Schema Information
#
# Table name: transport_locations
#
#  id               :bigint           not null, primary key
#  max_participants :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :transport_location do
    name { Faker::Lorem.words(number: 3) }
    max_participants { (100..200).to_a.sample }
  end
end
