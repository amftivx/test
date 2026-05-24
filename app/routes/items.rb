ITEMS = ItemRepository.new

get '/items' do
  ITEMS.all.map(&:to_api).to_json
end

get '/items/:id' do
  item = ITEMS.find(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless item
  item.to_api.to_json
end

post '/items' do
  attrs = JSON.parse(request.body.read)
  item = ITEMS.create(attrs)
  status 201
  item.to_api.to_json
end

put '/items/:id' do
  attrs = JSON.parse(request.body.read)
  item = ITEMS.update(params[:id].to_i, attrs)
  halt 404, { error: 'not found' }.to_json unless item
  item.to_api.to_json
end

delete '/items/:id' do
  item = ITEMS.delete(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless item
  status 204
end
