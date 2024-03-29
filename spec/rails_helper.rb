# Load dotenv file(s) manually
require 'dotenv'
Dotenv.load(File.expand_path('../.env.test'))

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# rubocop:disable Style/IfUnlessModifier
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
# rubocop:enable Style/IfUnlessModifier

require 'spec_helper'
require 'rspec/rails'

# Only require the top-level files that are one level deep
# All support/** sub-folders should be required by the top-level files
Dir[Rails.root.join('spec/support/*.rb')].each { |file| require file }

# Maintain the test schema to match the development schema at all times
ActiveRecord::Migration.maintain_test_schema!
