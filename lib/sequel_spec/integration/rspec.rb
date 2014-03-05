require 'rspec/core'

RSpec.configure do |config|
  config.include SequelSpec::Matchers::Validation
  config.include SequelSpec::Matchers::Association
end
