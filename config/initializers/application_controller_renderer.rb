# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

ActiveSupport::Reloader.to_prepare do
  ApplicationController.renderer.defaults.merge!(
    http_host: ENV.fetch('APP_HOST'),
    https: false
  )
end
