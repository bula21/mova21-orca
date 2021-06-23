# frozen_string_literal: true

class PullAllCampUnitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Stufe.where.not(root_camp_unit_id: nil).each do |stufe|
      CampUnitPuller.new(stufe).pull_all
    end
  end
end
