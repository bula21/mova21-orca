# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LimesurveyService do
  describe '#get_session_key' do
    it 'returns a session key' do
      body = '{"id":1,"result":"1KPmoylQuRSh8_5dU2mTWB~dzz2qhZ0u","error":null}'
      stub_request(:post, LimesurveyService::ADMIN_REMOTECONTROL_URL).to_return(body: body)
      service = described_class.new('username', 'password')
      session_key = service.get_session_key('username', 'password')
      expect(session_key).to eq '1KPmoylQuRSh8_5dU2mTWB~dzz2qhZ0u'
    end
  end
end
