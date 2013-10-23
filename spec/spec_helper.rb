require 'rack/test'
require 'faraday'
require 'omniauth'
require 'omniauth-aveda-purepro'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include Rack::Test::Methods
end
