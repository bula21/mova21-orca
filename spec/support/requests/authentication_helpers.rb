# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'a login protected page' do
  subject { response }

  before { test_request }

  it { is_expected.to redirect_to new_user_session_path }
end
