# frozen_string_literal: true

class SmsSender
  def initialize(numbers, message)
    @numbers = numbers
    @message = message
  end

  def send
    url = URI(ENV.fetch('SMS_SENDER_URL'))
    token = ENV.fetch('SMS_SENDER_TOKEN')

    body = {
      phonenumbers: @numbers,
      message: @message
    }
    request(url, body, token)
  end

  private

  def request(url, body, token) # rubocop:disable Metrics/MethodLength
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(Net::HTTP::Post.new(url).tap do |r|
        r.body = JSON.generate(body)
        r['Content-Type'] = 'application/json'
        r['Authorization'] = "Bearer #{token}"
      end)
    end

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise StandardError, "Could not send Message: #{response.body}"
    end
  end
end
