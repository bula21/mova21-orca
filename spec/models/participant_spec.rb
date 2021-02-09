# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  birthdate  :date
#  first_name :string
#  gender     :string
#  last_name  :string
#  scout_name :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pbs_id     :integer
#  unit_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#
require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject(:participant) { create(:participant, units: [unit]) }

  let(:unit) { create :unit }

  let(:params) { attributes_for :participant }

  it { is_expected.to validate_uniqueness_of(:pbs_id) }
end
