# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { described_class.new(params) }

  let(:params) { attributes_for :tag }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:icon) }
  it { is_expected.to validate_presence_of(:label) }
end
