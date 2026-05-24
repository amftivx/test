ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'json'
require 'sequel'

require_relative '../config/database'

Sequel.extension :migration
Sequel::Migrator.run(DB, 'db/migrate')

require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    DB[:items].truncate(cascade: true, restart: true)
    DB[:tags].truncate(cascade: true, restart: true)
  end

  def app
    Sinatra::Application
  end
end
