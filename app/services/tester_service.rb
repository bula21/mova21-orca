# frozen_string_literal: true

# rubocop:disable all
class TesterService
  TN_RANGE = (14..144).freeze
  LEITUNG_RANGE = (2..15).freeze
  STUFEN = %i[wolf pfadi pio].freeze

  def add_all_test_units(testers)
    testers.each { |tester| add_test_units(**tester) }
  end

  def add_test_unit(lagerleiter:, title:, stufe:, tn:, leitung:, language: :de)
    I18n.with_locale(language) do
      Unit.create!(title: title, stufe: stufe, abteilung: abteilung, lagerleiter: lagerleiter, kv: kv,
                   expected_participants_leitung_f: (leitung / 2), expected_participants_leitung_m: (leitung / 2),
                   expected_participants_m: (tn / 2), expected_participants_f: (tn / 2), language: language,
                   ends_at: Date.new(2022, 7, 20), starts_at: Date.new(2022, 7, 30), activity_booking_phase: 1)
    end
  end

  def add_test_units(email:, scout_name: '', first_name: '', last_name: '', abteilung: '',
                     kv: Kv.last, language: :de, units_per_stufe: 2)
    Unit.transaction do
      user = User.find_by(uid: email) || User.create!(uid: email, email: email, pbs_id: '', provider: 'developer')

      lagerleiter = Leader.create!(scout_name: scout_name, email: email, last_name: last_name, first_name: first_name,
                                   language: language, address: '-', zip_code: '-', town: '-', user: user,
                                   phone_number: '-')

      tn_slice_size = TN_RANGE.size / units_per_stufe
      leitung_slice_size = LEITUNG_RANGE.size / units_per_stufe

      STUFEN.each do |code|
        stufe = Stufe.find_by!(code: code)
        units_per_stufe.times do |i|
          tn = rand(TN_RANGE.begin + (tn_slice_size * i))..(TN_RANGE.begin + (tn_slice_size * (i + 1)))
          leitung = rand(LEITUNG_RANGE.begin + (leitung_slice_size * i))..(LEITUNG_RANGE.begin + (leitung_slice_size * (i + 1)))
          title = "#{abteilung} #{stufe.name} #{Unit.model_name.human} ##{i + 1}"

          add_test_unit(title: title, lagerleiter: lagerleiter, stufe: stufe, tn: tn, leitung: leitung,
                        language: language)
        end
      end
    end
  end
end
# rubocop:enable all
