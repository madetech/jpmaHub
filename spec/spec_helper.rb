require_relative '../api'
require 'builder/tgif'
require 'date'
require_relative '../db/migrator'
require 'domain/tgif'
require 'gateway/tgifs_gateway'
require 'sinatra'
require 'rack/test'
require 'database_cleaner'
require 'usecase/fetch_weekly_tgif'
require 'usecase/submit_tgif'
require 'usecase/delete_all_tgif'
require 'usecase/delete_team_tgif'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  def app
    described_class
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include Rack::Test::Methods
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { DatabaseCleaner.clean }

  config.before(:all) { DatabaseCleaner.start }

  config.after(:all) { DatabaseCleaner.clean }
end