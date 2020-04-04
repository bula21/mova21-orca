# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
# require "action_cable/engine"
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orca
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Zurich'
    config.i18n.default_locale = :de
    config.i18n.available_locales = %i[en de it fr]
    config.i18n.fallbacks = { en: :de, de: :fr, fr: :en }
  end
end
