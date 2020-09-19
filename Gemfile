# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'ancestry'
gem 'annotate'
gem 'azure-storage', '~> 0.15.0.preview', require: false
gem 'bitfields'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cancancan'
gem 'devise'
gem 'grape-entity'
gem 'httparty'
gem 'keycloak'
gem 'mobility', '~> 0.8.9'
gem 'omniauth_openid_connect'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.1'
gem 'rails-i18n'
gem 'react-rails'
gem 'redcarpet'
gem 'rollbar'
gem 'simple_form'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'vcr'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.11'
  gem 'faker'
  gem 'i18n-tasks'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
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

gem 'webmock', '~> 3.8'

gem 'prawn', '~> 2.2'
gem 'prawn-table'
