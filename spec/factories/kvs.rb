# frozen_string_literal: true

FactoryBot.define do
  factory :kv do
    sequence(:pbs_id) { |n| n }

    trait :ge do
      pbs_id { 234 }
      name { 'AS Genevois' }
      locale { :fr }
    end

    trait :ju do
      pbs_id { 397 }
      name { 'AS Jurassienne' }
      locale { :fr }
    end

    trait :vs do
      pbs_id { 391 }
      name { 'AS Valaisan' }
      locale { :fr }
    end

    trait :gr do
      pbs_id { 57 }
      name { 'Battasendas Grischun' }
      locale { :de }
    end

    trait :ag do
      pbs_id { 400 }
      name { 'Pfadi Aargau' }
      locale { :de }
    end

    trait :gl do
      pbs_id { 425 }
      name { 'Pfadi Glarus' }
      locale { :de }
    end

    trait :be do
      pbs_id { 2 }
      name { 'Pfadi Kanton Bern' }
      locale { :de }
    end

    trait :lu do
      pbs_id { 49 }
      name { 'Pfadi Kanton Luzern' }
      locale { :de }
    end

    trait :sz do
      pbs_id { 426 }
      name { 'Pfadi Kanton Schwyz' }
      locale { :de }
    end

    trait :so do
      pbs_id { 428 }
      name { 'Pfadi Kanton Solothurn' }
      locale { :de }
    end

    trait :zg do
      pbs_id { 424 }
      name { 'Pfadi Kanton Zug' }
      locale { :de }
    end

    trait :sh do
      pbs_id { 205 }
      name { 'Pfadi Kantonalverband Schaffhausen' }
      locale { :de }
    end

    trait :blbs do
      pbs_id { 429 }
      name { 'Pfadi Region Basel' }
      locale { :de }
    end

    trait :sgarai do
      pbs_id { 64 }
      name { 'Pfadi St. Gallen – Appenzell' }
      locale { :de }
    end

    trait :tg do
      pbs_id { 80 }
      name { 'Pfadi Thurgau' }
      locale { :de }
    end

    trait :uw do
      pbs_id { 166 }
      name { 'Pfadi Unterwalden' }
      locale { :de }
    end

    trait :ur do
      pbs_id { 427 }
      name { 'Pfadi Uri' }
      locale { :de }
    end

    trait :zh do
      pbs_id { 3 }
      name { 'Pfadi Züri' }
      locale { :de }
    end

    trait :ti do
      pbs_id { 423 }
      name { 'Scoutismo Ticino' }
      locale { :it }
    end

    trait :fr do
      pbs_id { 70 }
      name { 'Scouts Fribourgeois' }
      locale { :de }
    end

    trait :ne do
      pbs_id { 156 }
      name { 'Scouts Neuchâtelois' }
      locale { :fr }
    end

    trait :vd do
      pbs_id { 4 }
      name { 'Scouts Vaudois' }
      locale { :fr }
    end
  end
end
