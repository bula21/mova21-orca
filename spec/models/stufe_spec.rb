# frozen_string_literal: true

# == Schema Information
#
# Table name: stufen
#
#  id         :bigint           not null, primary key
#  name       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Stufe, type: :model do
  subject(:stufe) { described_class.new(params) }

  let(:params) { attributes_for :stufe }

  it { is_expected.to validate_presence_of(:name) }
end
