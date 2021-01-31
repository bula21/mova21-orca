# frozen_string_literal: true

class MidataService
  include HTTParty
  attr_reader :auth_params

  base_uri ENV.fetch('MIDATA_BASE_URL', 'https://pbs.puzzle.ch')

  def initialize(user_email = ENV['MIDATA_USER_EMAIL'], user_token = ENV['MIDATA_USER_TOKEN'], _locale = 'de')
    @auth_params = { user_token: user_token, user_email: user_email }
  end

  def fetch_participations(group_id, event_id, page = 1)
    JSON.parse(self.class.get("/groups/#{group_id}/events/#{event_id}/participations.json",
                              query: auth_params.merge(page: page)).body)
  end

  def fetch_camp_unit_data(id)
    Rails.logger.debug "Talking to Midata Event #{id}"

    JSON.parse(self.class.get("/events/#{id}.json", query: auth_params).body)
  end

  def fetch_camp_unit_data_hierarchy(root_id)
    root_data = fetch_camp_unit_data(root_id)
    children_ids = root_data.dig('events', 0, 'links', 'sub_camps')

    return root_data if children_ids.nil?

    [root_data, children_ids.map { |child_id| fetch_camp_unit_data_hierarchy(child_id) }].flatten
  end
end
