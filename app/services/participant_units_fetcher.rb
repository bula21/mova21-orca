# frozen_string_literal: true

class ParticipantUnitsFetcher
  def initialize(pbs_group_id, camp_unit)
    @pbs_group_id = pbs_group_id
    @camp_unit = camp_unit
    @pbs_event_id = camp_unit.pbs_id
    @participant_units_builder = ParticipantUnitsBuilder.new
    @midata_service = MidataService.new
  end

  def call
    collect_raw_event_participation_data
    build_participant_units
  end

  private

  def build_participant_units
    @participant_units_builder.from_data(@raw_event_participation_data, @camp_unit)
  end

  def collect_raw_event_participation_data
    result = @midata_service.fetch_participations(@pbs_group_id, @pbs_event_id)
    @raw_event_participation_data = result.fetch('event_participations', [])
    while result.fetch('next_page_link')
      result = @midata_service.fetch_participations(@pbs_group_id, @pbs_event_id, result['current_page'] + 1)
      @raw_event_participation_data.push(*result.fetch('event_participations', []))
    end
  end
end
