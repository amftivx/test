require 'sinatra'
require 'json'

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

before { content_type :json }

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
