class StufenSeed < ActiveRecord::Migration[6.0]
  def change
    Stufe.create(name_de: 'Wolf', name_it: 'Lupetti', name_fr: 'Louveteaux', name_en: 'Cub Scout')
    Stufe.create(name_de: 'Pfadi', name_it: 'Esploratori', name_fr: 'Eclais', name_en: 'Scout')
    Stufe.create(name_de: 'Pio', name_it: 'Pionieri', name_fr: 'Picos', name_en: 'Venture Scout')
    Stufe.create(name_de: 'PTA', name_it: 'PTA', name_fr: 'SMT', name_en: 'PTA')
  end
end
