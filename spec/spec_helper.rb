require 'rubygems'
require 'rspec'
require 'sequel'
require 'database_cleaner'
require 'sequel_spec'

require 'support/test_helpers'

DB = Sequel.connect('sqlite://test.db')

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    Sequel.extension :migration
    Sequel::Migrator.apply(DB, 'spec/migrations')
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include TestHelpers
end
