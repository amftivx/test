require 'sequel'
require 'rspec/core/rake_task'
require_relative 'config/secrets'

Sequel.extension :migration

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :db do
  desc 'Run migrations'
  task :migrate do
    db = Sequel.connect(ENV.fetch('DATABASE_URL') { raise 'DATABASE_URL must be set' })
    Sequel::Migrator.run(db, 'db/migrate')
    puts 'Migrations complete'
  end

  desc 'Rollback last migration'
  task :rollback do
    db = Sequel.connect(ENV.fetch('DATABASE_URL') { raise 'DATABASE_URL must be set' })
    migrator = Sequel::Migrator.migrator_class('db/migrate').new(db, 'db/migrate')
    Sequel::Migrator.run(db, 'db/migrate', target: migrator.current - 1)
    puts 'Rollback complete'
  end

  desc 'Create the test database'
  task :create_test do
    test_url = ENV.fetch('TEST_DATABASE_URL', 'postgres://app:secret@localhost:5432/app_test')
    uri = URI.parse(test_url)
    db_name = uri.path.delete_prefix('/')
    admin_url = "#{uri.scheme}://#{uri.userinfo}@#{uri.host}:#{uri.port}/postgres"
    db = Sequel.connect(admin_url)
    db.run("CREATE DATABASE #{db_name}")
    db.disconnect
    puts "Created database #{db_name}"
  rescue Sequel::DatabaseError => e
    raise unless e.message.include?('already exists')
    puts "Database #{db_name} already exists, skipping"
  end
end
