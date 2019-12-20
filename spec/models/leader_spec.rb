# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Leader, type: :model do
  subject(:leader) { described_class.new(params) }
  let(:params) { attributes_for :leader }

  it { is_expected.to validate_presence_of(:email) }
end
