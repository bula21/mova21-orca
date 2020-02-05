class MidataService
  include HTTParty
  base_uri ENV.fetch('MIDATA_BASE_URL', 'https://pbs.puzzle.ch')

  def initialize(user_email, user_token, locale = 'de')
    @auth_params = { user_token: user_token, user_email: user_email }
  end

  def fetch_camp(id)
    self.class.get("/events/#{id}.json", query: @auth_params)
  end
end
