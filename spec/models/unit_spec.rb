# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Unit, type: :model do
  subject(:unit) { described_class.new(params) }
  let(:params) { attributes_for :unit }

  it { is_expected.to validate_presence_of(:title) }
end
