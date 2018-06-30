# frozen_string_literal: true

if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'honey_format'
require 'byebug'
