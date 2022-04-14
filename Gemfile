# frozen_string_literal: true

ruby '3.1.2' # See Dockerfile
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'ancestry'
gem 'annotate'
gem 'azure-storage-blob', require: false
gem 'bitfields'
gem 'blueprinter'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cancancan'
gem 'devise'
gem 'grape-entity'
gem 'httparty'
gem 'kaminari'
gem 'keycloak'
gem 'matrix'
gem 'mobility', '~> 1.2.5'
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'omniauth_openid_connect', '~> 0.3.5' # TODO: upgrade
gem 'pg', '>= 0.18', '< 2.0'
gem 'prawn', '~> 2.2'
gem 'prawn-table'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.1.0'
gem 'rails-i18n', '~> 6.0'
gem 'ranked-model'
gem 'react-rails'
gem 'redcarpet'
gem 'rollbar'
gem 'roo'
gem 'shakapacker', '= 6.1'
gem 'simple_form'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'vcr'
gem 'webmock', '~> 3.8'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails', '~> 4.11'
  gem 'faker'
  gem 'i18n-tasks'
  gem 'locales_export_import'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '>= 3.0.5' # , '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'super_diff'
  gem 'webdrivers'
end
