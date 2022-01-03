# frozen_string_literal: true

class MidataService
  include HTTParty
  attr_reader :auth_params

  base_uri ENV.fetch('MIDATA_BASE_URL', 'https://pbs.puzzle.ch')

  def initialize(user_email = ENV['MIDATA_USER_EMAIL'], user_token = ENV['MIDATA_USER_TOKEN'], _locale = 'de')
    @auth_params = { 'X-User-Token': user_token, 'X-User-Email': user_email }
  end

  def fetch_participations(group_id, event_id, page = 1)
    Rails.logger.debug do
      "URL: #{"/groups/#{group_id}/events/#{event_id}/participations.json"}, QUERY: #{{ page: page }}"
    end
    JSON.parse(self.class.get("/groups/#{group_id}/events/#{event_id}/participations.json",
                              query: { page: page }, headers: auth_params).body)
  end

  def fetch_camp_unit_data(root_url)
    Rails.logger.debug { 'Talking to Midata Event' }
    Rails.logger.debug { "URL: #{root_url}" }

    JSON.parse(self.class.get(root_url.sub(self.class.base_uri, ''), headers: auth_params).body)
  end

  def fetch_camp_unit_data_hierarchy(root_url, root: true)
    # TODO: Cleanup: Pass a url from the very top (now the top-event is fetched by id, then all the others by url)
    root_data = fetch_camp_unit_data(root ? "/events/#{root_url}.json" : root_url)
    children_ids = root_data.dig('events', 0, 'links', 'sub_camps')

    return root_data if children_ids.nil? && !root

    events_data = root_data.dig('linked', 'events')
    children_urls = children_ids.map do |subcamp_id|
      events_data.find { |d| d['id'] == subcamp_id }['href']
    end

    [root_data, children_urls.map { |child_url| fetch_camp_unit_data_hierarchy(child_url, root: false) }].flatten
  end
end
