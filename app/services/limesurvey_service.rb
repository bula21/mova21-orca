# frozen_string_literal: true

class LimesurveyService
  BASEURL = 'https://localhost/limesurvey/'
  ADMIN_REMOTECONTROL_URL = URI.parse(BASEURL + '/admin/remotecontrol')

  attr_reader :session_key

  def initialize(username, password)
    # @session_key = get_session_key(username, password)
  end

  # receive session key
  def get_session_key(username, password, _plugin = 'Authdb')
    response = request(ADMIN_REMOTECONTROL_URL, 'get_session_key', [username, password])
    JSON.parse(response.body)
  end

  # release the session key
  def release_session_key
    response = request(ADMIN_REMOTECONTROL_URL, 'release_session_key', [session_key])
    JSON.parse(response.body)
  end

  # receive surveys list current user can read
  def list_surveys
    response = request(ADMIN_REMOTECONTROL_URL, 'list_surveys', [session_key])
    JSON.parse(response.body)
  end

  # adds user to a survey
  # [ {"email":"me@example.com","lastname":"Bond","firstname":"James"},
  #   {"email":"me2@example.com","attribute_1":"example"} ]
  def add_participants(survey_id, user)
    response = request(ADMIN_REMOTECONTROL_URL, 'add_participants', [session_key, survey_id, user])
    JSON.parse(response.body)
  end

  private

  def request(url, method, params)
    body = { method: method, params: params }
    request = Net::HTTP::Post.new(url).tap do |r|
      r.body = JSON.generate(body)
      r['Content-Type'] = 'application/json'
      r['connection'] = 'Keep-Alive'
    end
    request
  rescue Timeout::Error, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
    raise e
  end
end
