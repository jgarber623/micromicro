$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'

require 'micromicro'

Dir[File.expand_path('../spec/support/*.rb', __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FixturesHelpers
end
