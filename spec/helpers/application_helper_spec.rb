# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#language_change_url_for' do
    subject { helper.language_change_url_for(locale) }

    let(:locale) { :fr }

    before do
      helper.params[:controller] = 'units'
      helper.params[:action] = 'index'
    end

    it { is_expected.to eq('/units?locale=fr') }
  end
end
