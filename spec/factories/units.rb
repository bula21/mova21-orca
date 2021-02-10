# frozen_string_literal: true

FactoryBot.define do
  factory :unit, aliases: %i[camp_unit] do
    sequence(:pbs_id) { |n| n }
    title { Faker::Movies::StarWars.planet }
    abteilung { Faker::Company.name }
    kv do
      kv_build = build(:kv, %i[ge ju vs gr ag gl be lu sz so zg sh blbs sgarai tg uw ur zh ti fr ne vd].sample)
      kv_in_db = Kv.where(pbs_id: kv_build.pbs_id)
      kv_in_db.empty? ? kv_build : kv_in_db[0]
    end
    stufe { Unit.stufen.keys.sample }
    expected_participants_f { (10..20).to_a.sample }
    expected_participants_m { (10..20).to_a.sample }
    expected_participants_leitung_f { (2..10).to_a.sample }
    expected_participants_leitung_m { (2..10).to_a.sample }
    starts_at { Faker::Date.in_date_period(year: 2021, month: 7) }
    ends_at { Faker::Date.in_date_period(year: 2021, month: 8) }
    al { build(:user).leader }
    lagerleiter { build(:user).leader }
  end
end
