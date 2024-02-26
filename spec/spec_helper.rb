# frozen_string_literal: true

require "quidax"
require "dotenv/load"
require "webmock/rspec"

# Mocks
require "quidax/mocks/user_mock"
require "quidax/mocks/wallet_mock"
require "quidax/mocks/withdrawal_mock"
require "quidax/mocks/markets_mock"
require "quidax/mocks/quotes_mock"
require "quidax/mocks/fees_mock"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
