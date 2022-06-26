# frozen_string_literal: true

module FrozenFoodTimeslotHelper
    require "time"

    def frozen_food_timeslot_frontend(timeslot)
        timeslot.squish!
        matches = timeslot.match(/((\d?\d).(\d?\d))-((\d?\d).(\d?\d))/)

        if matches
            timeslot_1 = (Time.parse(matches[1].gsub(".", ":")) - 5.hours).strftime("%H.%M") 
            timeslot_2 = (Time.parse(matches[4].gsub(".", ":")) - 5.hours).strftime("%H.%M") 
            
            timeslot = timeslot_1 + "-" + timeslot_2
        else
            timeslot = "not possible to calculate time"
        end

        timeslot
    end
  end
  