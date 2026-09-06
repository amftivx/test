RSpec.describe 'Items API' do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'GET /items' do
    it 'returns 200 with an empty array when no items exist' do
      get '/items'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([])
    end

    it 'returns all items' do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      post '/items', { name: 'Gadget', description: 'A cool gadget' }.to_json, headers

      get '/items'
      body = JSON.parse(last_response.body)
      expect(body.length).to eq(2)
      expect(body.map { |i| i['name'] }).to contain_exactly('Widget', 'Gadget')
    end
  end

  describe 'GET /items/:id' do
    it 'returns 200 with the item when found' do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      get "/items/#{id}"
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['name']).to eq('Widget')
      expect(body['description']).to eq('A fine widget')
    end

    it 'returns 404 when not found' do
      get '/items/999'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end

  describe 'GET /items/search' do
    before do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      post '/items', { name: 'Gadget', description: 'A widget-adjacent gadget' }.to_json, headers
      post '/items', { name: 'Doohickey', description: 'Unrelated' }.to_json, headers
    end

    it 'matches on name' do
      get '/items/search?q=doohickey'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body.map { |i| i['name'] }).to eq(['Doohickey'])
    end

    it 'matches on description and is case-insensitive' do
      get '/items/search?q=WIDGET'
      body = JSON.parse(last_response.body)
      expect(body.map { |i| i['name'] }).to contain_exactly('Widget', 'Gadget')
    end

    it 'returns an empty array when nothing matches' do
      get '/items/search?q=nope'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([])
    end

    it 'returns 400 when q is missing or blank' do
      get '/items/search'
      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body)['error']).to eq('q is required')
    end

    it 'does not shadow GET /items/:id' do
      get '/items/1'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['name']).to eq('Widget')
    end
  end

  describe 'POST /items' do
    it 'returns 201 with the created item including an id' do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      expect(last_response.status).to eq(201)
      body = JSON.parse(last_response.body)
      expect(body['id']).to be_a(Integer)
      expect(body['name']).to eq('Widget')
      expect(body['description']).to eq('A fine widget')
    end

    it 'auto-increments ids' do
      post '/items', { name: 'First', description: '' }.to_json, headers
      first_id = JSON.parse(last_response.body)['id']
      post '/items', { name: 'Second', description: '' }.to_json, headers
      second_id = JSON.parse(last_response.body)['id']
      expect(second_id).to eq(first_id + 1)
    end
  end

  describe 'PUT /items/:id' do
    it 'returns 200 with the updated item when found' do
      post '/items', { name: 'Widget', description: 'Old' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      put "/items/#{id}", { name: 'Widget Pro', description: 'New' }.to_json, headers
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['name']).to eq('Widget Pro')
      expect(body['description']).to eq('New')
      expect(body['id']).to eq(id)
    end

    it 'returns 404 when not found' do
      put '/items/999', { name: 'X', description: 'Y' }.to_json, headers
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end

  describe 'DELETE /items/:id' do
    it 'returns 204 with no body when found' do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      delete "/items/#{id}"
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_empty
    end

    it 'removes the item from the store' do
      post '/items', { name: 'Widget', description: 'A fine widget' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      delete "/items/#{id}"
      get "/items/#{id}"
      expect(last_response.status).to eq(404)
    end

    it 'returns 404 when not found' do
      delete '/items/999'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end
end
