# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LimesurveyService do
  describe '#get_session_key' do
    it 'returns a session key' do
      stub_request(:any, LimesurveyService::BASEURL)
      service = described_class.new('username', 'password')
      session_key = service.get_session_key('username', 'password')
      expect(session_key).not_to eq nil
    end
  end
end
