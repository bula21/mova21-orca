# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitiesController, type: :request do
  describe 'GET #index' do
    before { get activities_path }

    it { expect(response).to be_successful }
  end
end
