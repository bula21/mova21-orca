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

    trait :wolf do
      name_de { 'Wolf' }
      name_it { 'Lupetti' }
      name_fr { 'Wolf' }
      name_en { 'Scout' }
    end

    trait :pfadi do
      name_de { 'Pfadi' }
      name_it { 'Esploratori' }
      name_fr { 'Eclais' }
      name_en { 'Scout' }
    end

    trait :pio do
      name_de { 'Pio' }
      name_it { 'Pionieri' }
      name_fr { 'Picos' }
      name_en { 'Venture Scout' }
    end

    trait :pta do
      name_de { 'PTA' }
      name_it { 'PTA' }
      name_fr { 'SMT' }
      name_en { 'PTA' }
    end
  end
end
