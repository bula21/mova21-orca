# frozen_string_literal: true

# == Schema Information
#
# Table name: goals
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Goal, type: :model do
  subject(:goal) { described_class.new(params) }

  let(:params) { attributes_for :goal }

  it { is_expected.to validate_presence_of(:name) }
end
