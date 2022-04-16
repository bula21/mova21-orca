# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'webmock/rspec'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'vcr'
require 'super_diff/rspec-rails'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<MIDATA_OAUTH_ACCESS_TOKEN>') { ENV['MIDATA_OAUTH_ACCESS_TOKEN'] }

  # config.default_cassette_options = { record: :all }
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.after do
    # rubocop:disable Rails/I18nLocaleAssignment
    I18n.locale = I18n.default_locale
    # rubocop:enable Rails/I18nLocaleAssignment
  end

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :view
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
