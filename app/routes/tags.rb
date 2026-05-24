TAGS = TagRepository.new

get '/tags' do
  TAGS.all.map(&:to_api).to_json
end

get '/tags/:id' do
  tag = TAGS.find(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless tag
  tag.to_api.to_json
end

post '/tags' do
  attrs = JSON.parse(request.body.read)
  tag = TAGS.create(attrs)
  status 201
  tag.to_api.to_json
end

put '/tags/:id' do
  attrs = JSON.parse(request.body.read)
  tag = TAGS.update(params[:id].to_i, attrs)
  halt 404, { error: 'not found' }.to_json unless tag
  tag.to_api.to_json
end

delete '/tags/:id' do
  tag = TAGS.delete(params[:id].to_i)
  halt 404, { error: 'not found' }.to_json unless tag
  status 204
end
