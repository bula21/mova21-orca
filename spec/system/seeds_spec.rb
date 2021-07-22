# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'seeds.rb' do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('MIDATA_BASE_URL').and_return('pbs.puzzle.ch')
  end

  it 'populates the app with some data' do
    load(Rails.root.join('db/seeds.rb'))
    expect(Leader.count).to eq(2)
    expect(ActivityCategory.count).to eq(4)
    expect(Activity.count).to eq(20)
    expect(Spot.count).to eq(2)
    expect(ActivityExecution.count).to eq(80)
    expect(Unit.count).to eq(2)
    expect(Kv.count).to eq(22)
    expect(Stufe.count).to eq(4)
  end
end
# rubocop:enable RSpec/DescribeClass
