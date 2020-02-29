# frozen_string_literal: true

class LimesurveyService
  BASEURL = 'https://limesurvey.bula21.ch/index.php'
  ADMIN_REMOTECONTROL_URL = URI.parse(BASEURL + '/admin/remotecontrol')

  attr_reader :session_key
  def initialize(username = ENV['LIMESURVEY_USERNAME'], password = ENV['LIMESURVEY_PASSWORD'])
    @session_key = get_session_key(username, password)
  end

  # adds leader to the survey, saves the token and sends an invite
  def add_leader(leader, unit, survey_id, language = 'de')
    response = add_participant(survey_id, leader.email, "#{leader.first_name} #{leader.last_name}", leader.scout_name,
                               unit.pbs_id, unit.stufe, language)
    return unless response.is_a?(Array) && response[0]['token']

    unit.update(limesurvey_token: response[0]['token'])
    invite_participants(survey_id)
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
  def add_participants(survey_id, users)
    response = request(ADMIN_REMOTECONTROL_URL, 'add_participants', [session_key, survey_id, users])
    response['result']
  end

  # 1: wolf, 5: pta
  def add_participant(survey_id, email, lastname, firstname, camp_id, stufe, language) # rubocop:disable Metrics/ParameterLists
    stufen = { 'wolf': 1, 'pfadi': 2, 'pio': 3, 'pta': 4 }
    user = { email: email, lastname: lastname, firstname: firstname, language: language,
             attribute_1: camp_id, attribute_2: stufen[stufe.to_sym] }
    add_participants(survey_id, [user])
  end

  def invite_participants(survey_id)
    request(ADMIN_REMOTECONTROL_URL, 'invite_participants', [session_key, survey_id])
  end

  private

  def request(url, method, params) # rubocop:disable Metrics/MethodLength
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
