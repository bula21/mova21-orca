# frozen_string_literal: true

class MidataService
  include HTTParty
  attr_reader :auth_params
  base_uri ENV.fetch('MIDATA_BASE_URL', 'https://pbs.puzzle.ch')

  def initialize(user_email = ENV['MIDATA_USER_EMAIL'], user_token = ENV['MIDATA_USER_TOKEN'], _locale = 'de')
    @auth_params = { user_token: user_token, user_email: user_email }
  end

  def fetch_camp_unit_data(id)
    JSON.parse(self.class.get("/events/#{id}.json", query: auth_params).body)
    # rescue
    #   {}
  end

  def fetch_camp_unit_data_hierarchy(root_id)
    root_data = fetch_camp_unit_data(root_id)
    children_ids = camp_unit_data.dig
    pp camp_unit_data

    [root_data, children_ids.map { |child_id| fetch_camp_unit_data_hierarchy(child_id) }].flatten
  end
end
