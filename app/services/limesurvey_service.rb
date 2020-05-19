# frozen_string_literal: true

class LimesurveyService
  BASEURL = 'https://limesurvey.bula21.ch/index.php'
  ADMIN_REMOTECONTROL_URL = URI.parse(BASEURL + '/admin/remotecontrol')

  def initialize(username = ENV['LIMESURVEY_USERNAME'],
                 password = ENV['LIMESURVEY_PASSWORD'],
                 survey_id = ENV['LIMESURVEY_SURVEY_ID'])
    @survey_id = survey_id
  end

  def session_key
    @session_key ||= fetch_session_key(username, password)
  end

  def url(token:, lang: nil)
    return nil unless token.present?

    "#{BASEURL}/#{@survey_id}?lang=#{lang}&token=#{token}"
  end

  def self.enabled?
    ENV['LIMESURVEY_SURVEY_ID'].present?
  end

  # adds leader to the survey, saves the token and sends an invite
  def add_leader(leader, unit)
    response = add_participant(leader.email, leader.first_and_last_name, leader.scout_name,
                               unit.pbs_id, unit.stufe, lime_lang(leader.language || unit.kv.locale))

    token = response&.dig(0, 'token').presence
    return unless token

    invite_participants
    token
  end

  # receive session key
  def fetch_session_key(username, password, _plugin = 'Authdb')
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

  def list_groups
    response = request(ADMIN_REMOTECONTROL_URL, 'list_groups', [session_key, @survey_id])
    response['result']
  end

  def fetch_survey_properties
    response = request(ADMIN_REMOTECONTROL_URL, 'get_survey_properties', [session_key, @survey_id])
    response['result']
  end

  # adds user to a survey
  # [ {"email":"james@example.com","lastname":"Bond","firstname":"James", "attribute_1": camp_id, "attribute_2": stufe},
  #   {"email":"me2@example.com","attribute_1":"example"} ]
  def add_participants(users)
    response = request(ADMIN_REMOTECONTROL_URL, 'add_participants', [session_key, @survey_id, users])
    response['result']
  end

  # rubocop:disable Metrics/ParameterLists
  def add_participant(email, lastname, firstname, camp_id, stufe, language)
    stufen = { 'wolf': 1, 'pfadi': 2, 'pio': 3, 'pta': 5 }
    user = { email: email, lastname: lastname, firstname: firstname, language: language,
             attribute_1: camp_id, attribute_2: stufen[stufe.to_sym] }

    add_participants([user])
  end
  # rubocop:enable Metrics/ParameterLists

  def invite_participants
    request(ADMIN_REMOTECONTROL_URL, 'invite_participants', [session_key, @survey_id])
  end

  private

  def request(url, method, params)
    Rails.logger.debug "Talking to Limesurvey: #{url} #{method}, #{params.inspect}"

    body = { method: method, params: params, id: 1 }
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(Net::HTTP::Post.new(url).tap do |r|
        r.body = JSON.generate(body)
        r['Content-Type'] = 'application/json'
        r['connection'] = 'Keep-Alive'
      end)
    end
    JSON.parse(response.body)
  end

  def lime_lang(locale)
    case locale&.to_sym
    when :it
      'it-informal'
    when :fr
      'fr'
    else
      'de-informal'
    end
  end
end
