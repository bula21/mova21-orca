# frozen_string_literal: true

class CampUnitPuller
  include MidataHelper

  def initialize(stufe)
    @stufe = stufe
    @camp_unit_builder = CampUnitBuilder.new(stufe)
    @midata_service = MidataService.new
  end

  def pull(pbs_id: nil, camp_unit_data: nil)
    camp_unit_data = camp_unit_data(camp_unit_data, pbs_id) # TODO: Fix this prod hack
    camp_unit = @camp_unit_builder.from_data(camp_unit_data)
    return unless camp_unit

    pbs_group_id = group_of_camp(camp_unit_data)&.[]('id')

    camp_unit.participant_units = fetch_unit_participants(camp_unit, pbs_group_id)
    camp_unit.save!
    camp_unit
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.message
    nil
  end

  def pull_all
    camp_unit_data_hierarchy = @midata_service.fetch_camp_unit_data_hierarchy(@stufe.root_camp_unit_id)
    camp_unit_data_hierarchy.filter_map { |camp_unit_data| pull(camp_unit_data: camp_unit_data) }
  end

  def pull_new
    root_data = @midata_service.fetch_camp_unit_data("/events/#{@stufe.root_camp_unit_id}.json")
    children_ids = root_data.dig('events', 0, 'links', 'sub_camps') || []
    existing_ids = Unit.all.pluck(:pbs_id) || []

    (children_ids - existing_ids).filter_map { |new_camp_unit_id| pull(pbs_id: new_camp_unit_id) }
  end

  private

  def fetch_unit_participants(camp_unit, pbs_group_id)
    manual_non_midata_participants = camp_unit.participant_units.select { |participant_unit| participant_unit.participant.pbs_id.nil? }
    midata_participants = ParticipantUnitsFetcher.new(pbs_group_id, camp_unit).call
    [*manual_non_midata_participants, *midata_participants]
  end

  def camp_unit_data(camp_unit_data, pbs_id)
    camp_unit_data ||= @midata_service.fetch_camp_unit_data("/events/#{pbs_id}.json")

    camp_unit_data = { 'events' => camp_unit_data.last } if camp_unit_data.is_a?(Array)
    camp_unit_data
  end
end
