# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityExecutionHelper, type: :helper do
  describe '#available_languages_for_frontend' do
    subject { helper.available_languages_for_frontend(activity_execution) }

    let(:activity_execution) { build(:activity_execution, language_flags: 5) }

    it { is_expected.to eq(%w[de it]) }
  end
end
