ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'json'
require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    ItemStore.reset
    TagStore.reset
  end

  def app
    Sinatra::Application
  end
end
