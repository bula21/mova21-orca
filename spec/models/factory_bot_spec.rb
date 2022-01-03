# frozen_string_literal: true

# https://github.com/thoughtbot/factory_bot/wiki/Testing-all-Factories-(with-RSpec)
require 'rails_helper'

RSpec.describe FactoryBot do
  described_class.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      it 'is valid' do
        factory = described_class.build(factory_name)
        expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") } if factory.respond_to?(:valid?)
      end

      described_class.factories[factory_name].definition.defined_traits.map(&:name).each do |trait_name|
        context "with trait #{trait_name}" do
          it 'is valid' do
            factory = described_class.build(factory_name, trait_name)
            expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") } if factory.respond_to?(:valid?)
          end
        end
      end
    end
  end
end
