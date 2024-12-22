# frozen_string_literal: true

require "rspec"
require "vcr"
require "pry"
require "pry-reload"
require "yaml"
require "uri"
require "json"
require "net/http"
require "active_support/time"
require "logger"
require "bitrix24"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.define_derived_metadata do |metadata|
    metadata[:aggregate_failures] = true
  end

  config.default_path = "spec/lib/bitrix24"

  config.order = :random

  config.full_backtrace = false

  config.profile_examples = 10

  config.filter_run_when_matching :focus

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end
end
