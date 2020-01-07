# frozen_string_literal: true

class LimesurveyService
  BASEURL = 'https://limesurvey.bula21.ch/index.php'
  ADMIN_REMOTECONTROL_URL = URI.parse(BASEURL + '/admin/remotecontrol')

  attr_reader :session_key

  def initialize(username, password)
    @session_key = get_session_key(username, password)
  end

  # receive session key
  def get_session_key(username, password, _plugin = 'Authdb')
    response = request(ADMIN_REMOTECONTROL_URL, 'get_session_key', [username, password])
    response['result']
  end

  # release the session key
  def release_session_key
    response = request(ADMIN_REMOTECONTROL_URL, 'release_session_key', [session_key])
    response['result']
  end

  # receive surveys list current user can read
  def list_surveys
    response = request(ADMIN_REMOTECONTROL_URL, 'list_surveys', [session_key])
    response['result']
  end

  def list_groups(survey_id)
    response = request(ADMIN_REMOTECONTROL_URL, 'list_groups', [session_key, survey_id])
    response['result']
  end

  def get_survey_properties(survey_id)
    response = request(ADMIN_REMOTECONTROL_URL, 'get_survey_properties', [session_key, survey_id])
    response['result']
  end

  # adds user to a survey
  # [ {"email":"james@example.com","lastname":"Bond","firstname":"James", "attribute_1": camp_id, "attribute_2": stufe},
  #   {"email":"me2@example.com","attribute_1":"example"} ]
  def add_participants(survey_id, user)
    response = request(ADMIN_REMOTECONTROL_URL, 'add_participants', [session_key, survey_id, user])
    response['result']
  end

  private

  def request(url, method, params)
    body = { method: method, params: params, id: 1 }
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(url).tap do |r|
        r.body = JSON.generate(body)
        r['Content-Type'] = 'application/json'
        r['connection'] = 'Keep-Alive'
      end
      http.request request
    end
    JSON.parse(response.body)
  rescue Timeout::Error, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
    raise e
  end
end
