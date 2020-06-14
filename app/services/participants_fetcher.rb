# frozen_string_literal: true

class ParticipantsFetcher
  def initialize(pbs_group_id, pbs_event_id)
    @pbs_group_id = pbs_group_id
    @pbs_event_id = pbs_event_id
    @participations_builder = ParticipantsBuilder.new
    @midata_service = MidataService.new
  end

  def call
    collect_raw_event_participation_data
    build_participation_objects
  end

  private

  def build_participation_objects
    @participations_builder.from_data(@raw_event_participation_data)
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
