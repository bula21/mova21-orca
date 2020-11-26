# frozen_string_literal: true

class PullAllCampUnitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    RootCampUnit.predefined.each_value do |root_camp_unit|
      root_camp_unit.puller.pull_all
    end
  end
end
