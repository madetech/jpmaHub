require 'builder/tgif'
require 'database_admin/postgres'
require_relative '../db/migrator'
require 'domain/tgif'
require 'gateway/sequel_tgif_gateway'
require 'usecase/fetch_weekly_tgif'
require 'usecase/submit_tgif'

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered

  database = DatabaseAdministrator::Postgres.new.fresh_database
  config.before(:all) { @database = database }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end