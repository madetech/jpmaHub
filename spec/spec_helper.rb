require_relative '../api'
require 'builder/tgif'
require 'date'
require 'database_admin/postgres'
require_relative '../db/migrator'
require 'domain/tgif'
require 'gateway/sequel_tgif_gateway'
require 'sinatra'
require 'rack/test'
require 'usecase/fetch_weekly_tgif'
require 'usecase/submit_tgif'
require 'usecase/delete_all_tgif'
require 'usecase/delete_team_tgif'
ENV['APP_ENV'] = 'test'

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

  database = Sequel.connect(ENV['DATABASE_URL'])
  config.before(:each) { @database = database[:tgif].delete }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end