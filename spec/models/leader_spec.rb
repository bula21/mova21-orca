# frozen_string_literal: true

# == Schema Information
#
# Table name: leaders
#
#  id           :bigint           not null, primary key
#  address      :string
#  birthdate    :date
#  country      :string
#  email        :string
#  first_name   :string
#  gender       :string
#  language     :string
#  last_name    :string
#  phone_number :string
#  scout_name   :string
#  town         :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pbs_id       :integer
#
require 'rails_helper'

RSpec.describe Leader, type: :model do
  subject(:leader) { described_class.new(params) }

  let(:params) { attributes_for :leader }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:pbs_id) }
end
