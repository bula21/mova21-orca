# frozen_string_literal: true

module FrozenFoodTimeslotHelper
  def frozen_food_timeslot(timeslot)
    matches = timeslot&.squish&.match(/((\d?\d).(\d?\d))-((\d?\d).(\d?\d))/)

    return I18n.t('units.show.food.parsing_error') unless matches

    [matches[1], matches[4]].map do |time|
      Time.zone = 'Europe/Zurich'
      (Time.zone.parse(time.tr('.', ':')) - 5.hours).strftime('%H.%M')
    end.join('-')
  end
end
