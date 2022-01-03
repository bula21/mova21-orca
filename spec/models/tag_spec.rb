# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  icon       :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { described_class.new(params) }

  let(:params) { attributes_for :tag }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:icon) }
  it { is_expected.to validate_presence_of(:label) }
end
