# frozen_string_literal: true

class PullNewCampUnitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Stufe.where.not(root_camp_unit_id: nil).each do |stufe|
      CampUnitPuller.new(stufe).pull_new
    end
  end
end
