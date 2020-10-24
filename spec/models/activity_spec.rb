# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject(:activity) { described_class.new(params) }

  let(:params) { attributes_for :activity }

  it { is_expected.to validate_presence_of(:label) }
  it { is_expected.to validate_presence_of(:description) }
end
