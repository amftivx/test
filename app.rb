require 'sinatra'
require 'json'
require_relative 'config/secrets'

module ItemStore
  @items = []
  @next_id = 1

  def self.reset
    @items = []
    @next_id = 1
  end

  def self.all
    @items
  end

  def self.find(id)
    @items.find { |i| i[:id] == id }
  end

  def self.create(attrs)
    item = { id: @next_id, name: attrs['name'], description: attrs['description'] }
    @next_id += 1
    @items << item
    item
  end

  def self.update(id, attrs)
    item = find(id)
    return nil unless item
    item[:name] = attrs['name']
    item[:description] = attrs['description']
    item
  end

  def self.delete(id)
    item = find(id)
    return nil unless item
    @items.delete(item)
    item
  end
end

module TagStore
  @tags = []
  @next_id = 1

  def self.reset
    @tags = []
    @next_id = 1
  end

  def self.all
    @tags
  end

  def self.find(id)
    @tags.find { |t| t[:id] == id }
  end

  def self.create(attrs)
    tag = { id: @next_id, name: attrs['name'], color: attrs['color'] }
    @next_id += 1
    @tags << tag
    tag
  end

  def self.update(id, attrs)
    tag = find(id)
    return nil unless tag
    tag[:name] = attrs['name']
    tag[:color] = attrs['color']
    tag
  end

  def self.delete(id)
    tag = find(id)
    return nil unless tag
    @tags.delete(tag)
    tag
  end
end

CHANGES = [
  { action: 'create', timestamp: '2026-05-20T10:00:00Z', description: 'Added Item endpoint' },
  { action: 'update', timestamp: '2026-05-21T14:30:00Z', description: 'Added description field to Item' },
  { action: 'delete', timestamp: '2026-05-22T09:15:00Z', description: 'Removed legacy /ping route' }
].freeze

# set JSON content type for all responses
before { content_type :json }

get '/changes' do
  CHANGES.to_json
end

get '/items' do
  ItemStore.all.to_json
end

get '/items/:id' do
  item = ItemStore.find(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless item
  item.to_json
end

post '/items' do
  attrs = JSON.parse(request.body.read)
  item = ItemStore.create(attrs)
  status 201
  item.to_json
end

put '/items/:id' do
  attrs = JSON.parse(request.body.read)
  item = ItemStore.update(params[:id].to_i, attrs)
  halt 404, { error: 'not found' }.to_json unless item
  item.to_json
end

delete '/items/:id' do
  item = ItemStore.delete(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless item
  status 204
end

get '/tags' do
  TagStore.all.to_json
end

get '/tags/:id' do
  tag = TagStore.find(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless tag
  tag.to_json
end

post '/tags' do
  attrs = JSON.parse(request.body.read)
  tag = TagStore.create(attrs)
  status 201
  tag.to_json
end

put '/tags/:id' do
  attrs = JSON.parse(request.body.read)
  tag = TagStore.update(params[:id].to_i, attrs)
  halt 404, { error: 'not found' }.to_json unless tag
  tag.to_json
end

delete '/tags/:id' do
  tag = TagStore.delete(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless tag
  status 204
end
