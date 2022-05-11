# frozen_string_literal: true

# This class surpresses errors on purpose to be able to show the status
# rubocop:disable Lint/SuppressedException
class HealthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:check]

  def check
    render json: {
      database: check_database,
      migrations: check_migrations,
      redis_cache: check_redis_cache
    }
  end

  private

  def check_database
    val = ActiveRecord::Base.connection.execute('select 1+2 as val').first['val']
    'OK' if val == 3
  rescue StandardError
    'NOK'
  end

  def check_migrations
    ActiveRecord::Base.connection.migration_context.needs_migration? ? 'NOK' : 'OK'
  rescue StandardError
  end

  def check_redis_cache
    return 'OK' if Rails.cache&.redis&.info.present?

    'NOK'
  rescue StandardError
    'NOK'
  end
end

# rubocop:enable Lint/SuppressedException
