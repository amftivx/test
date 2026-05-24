require 'sequel'
require_relative 'secrets'

DB = Sequel.connect(
  if ENV['RACK_ENV'] == 'test'
    ENV.fetch('TEST_DATABASE_URL', 'postgres://app:secret@localhost:5432/app_test')
  else
    ENV.fetch('DATABASE_URL') { raise 'DATABASE_URL must be set' }
  end
)

Sequel::Model.db = DB
