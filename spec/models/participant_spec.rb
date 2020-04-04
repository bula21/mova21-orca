# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject(:participant) { create(:participant, unit: unit) }

  let(:unit) { create :unit }

  let(:params) { attributes_for :participant }

  it { is_expected.to validate_uniqueness_of(:pbs_id) }
end
