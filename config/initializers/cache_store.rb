# frozen_string_literal: true

Rails.application.configure do
  if ENV['REDIS_URL'].present?
    config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', nil),
                                               connect_timeout: 30, # Defaults to 20 seconds
                                               read_timeout: 0.2, # Defaults to 1 second
                                               write_timeout: 0.2, # Defaults to 1 second
                                               reconnect_attempts: 1 } # ,   # Defaults to 0
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
end

Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
