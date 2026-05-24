require 'sinatra'
require 'json'

require_relative 'config/database'

require_relative 'app/models/item'
require_relative 'app/models/tag'
require_relative 'app/repositories/item_repository'
require_relative 'app/repositories/tag_repository'

CHANGES = [
  { action: 'create', timestamp: '2026-05-20T10:00:00Z', description: 'Added Item endpoint' },
  { action: 'update', timestamp: '2026-05-21T14:30:00Z', description: 'Added description field to Item' },
  { action: 'delete', timestamp: '2026-05-22T09:15:00Z', description: 'Removed legacy /ping route' }
].freeze

before { content_type :json }

get '/changes' do
  CHANGES.to_json
end

require_relative 'app/routes/items'
require_relative 'app/routes/tags'
