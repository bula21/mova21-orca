class MidataService
  include HTTParty
  attr_reader :auth_params
  base_uri ENV.fetch('MIDATA_BASE_URL', 'https://pbs.puzzle.ch')

  def initialize(user_email = ENV['MIDATA_USER_EMAIL'], user_token = ENV['MIDATA_USER_TOKEN'], locale = 'de')
    @auth_params = { user_token: user_token, user_email: user_email }
  end

  def fetch_camp_unit_data(id)
    JSON.parse(self.class.get("/events/#{id}.json", query: auth_params).body)
  # rescue
  #   {}
  end

  def pull_camp_unit(camp_unit_id)
    UnitParser.new(fetch_camp_unit_data(camp_unit_id)).call
  end

  def pull_camp_unit_structure(camp_unit_id)
    camp_unit_data = fetch_camp_unit_data(camp_unit_id)
    children_ids = camp_unit_data.dig()
    pp camp_unit_data

    { UnitParser.new(camp_unit_data).call => children_ids.map { |child_id| pull_camp_unit_structure(child_id) } }
  end
end
