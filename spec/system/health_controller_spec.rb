# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HealthController do
  it 'returns the correct response if the app is ok and connected to a database' do
    visit '/health/check'
    expect(page).to have_content('{"database":"OK","migrations":"OK","redis_cache":"OK"}')
  end
end
