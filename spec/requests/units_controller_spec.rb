# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitsController, type: :request do
  describe 'GET #index' do
    context 'when not signed in' do
      it_behaves_like 'a login protected page' do
        let(:test_request) { get units_path }
      end
    end

    context 'when signed in' do
      subject(:request) { get units_path, params: { format: format } }

      let(:user) { create(:user, :midata_user) }
      let(:leader) { create(:leader, pbs_id: user.pbs_id) }
      let!(:unit) { create(:unit, lagerleiter: leader) }
      let!(:unit_other) { create(:unit) }
      let(:format) { :html }

      before do
        sign_in user
      end

      context 'when format is html' do
        before do
          request
        end

        it { expect(response).to be_successful }
        it { expect(response.body).to include(unit.title) }
        it { expect(response.body).not_to include(unit_other.title) }

        context 'when is admin' do
          let(:user) { create(:user, :admin) }

          it { expect(response.body).to include(unit.title) }
          it { expect(response.body).to include(unit_other.title) }
        end
      end

      context 'when format is csv' do
        let(:format) { :csv }

        it { expect { request }.to raise_error(ActionController::UnknownFormat) }

        context 'when is admin' do
          let(:user) { create(:user, :admin) }

          before { request }

          it 'returns a csv' do
            expect(response.header['Content-Type']).to include 'text/csv'
          end

          it { expect(response.body).to include unit_other.title }
          it { expect(response.body).to include UnitExporter::HEADERS.join(',') }
        end
      end
    end
  end
end
