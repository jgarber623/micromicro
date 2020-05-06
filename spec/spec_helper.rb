require 'bundler/setup'
require 'micromicro'

Dir[File.expand_path('../spec/support/*.rb', __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FixturesHelpers

  config.disable_monkey_patching!
end
