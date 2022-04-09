# frozen_string_literal: true

module Orca
  CAMP_START = Date.parse(ENV.fetch('CAMP_START').presence || '2022-07-23')
  CAMP_END = Date.parse(ENV.fetch('CAMP_END').presence || '2022-08-06')
end
