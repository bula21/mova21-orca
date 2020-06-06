# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitiesController, type: :request do
  describe 'GET #index' do
    context 'when not signed in' do
      it_behaves_like 'a login protected page' do
        let(:test_request) { get activities_path }
      end
    end
  end
end
