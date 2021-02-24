# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  birthdate  :date
#  first_name :string
#  gender     :string
#  last_name  :string
#  scout_name :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pbs_id     :integer
#  unit_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#
FactoryBot.define do
  factory :participant do
    sequence(:pbs_id) { |n| n }
    last_name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    scout_name { Faker::Superhero.name }
    birthdate { Faker::Date.birthday(min_age: 5, max_age: 35) }
    gender { Participant.genders.keys.sample }
    unit
  end
end
