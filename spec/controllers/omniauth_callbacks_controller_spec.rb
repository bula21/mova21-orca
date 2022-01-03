# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniauthCallbacksController, skip: true do
  describe 'GET failure' do
    it 'redirects to root_path' do
      get :'callbacks/failure'
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET developer' do
    let(:auth) { double }

    before do
      request.env['omniauth.auth'] = auth
    end

    it 'redirects to root_path' do
      get :developer
      expect(response).to redirect_to(root_path)
    end
  end
end
