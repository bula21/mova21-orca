# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitiesController, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user, :midata_user) }

    before do
      sign_in user
      get activities_path
    end

    it { expect(response).to be_successful }
  end
end
