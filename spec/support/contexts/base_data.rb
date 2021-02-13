# frozen_string_literal: true

RSpec.shared_context 'with base data', shared_context: :metadata do
  let(:all_cantons) { %i[ge ju vs gr ag gl be lu sz so zg sh blbs sgarai tg uw ur zh ti fr ne vd] }
  before do
    all_cantons.each { |canton| create(:kv, canton) }
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'with base data', include_shared: true
end
