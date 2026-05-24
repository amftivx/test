RSpec.describe 'Tags API' do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'GET /tags' do
    it 'returns 200 with an empty array when no tags exist' do
      get '/tags'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([])
    end

    it 'returns all tags' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      post '/tags', { name: 'Go', color: '#00acd7' }.to_json, headers

      get '/tags'
      body = JSON.parse(last_response.body)
      expect(body.length).to eq(2)
      expect(body.map { |t| t['name'] }).to contain_exactly('Ruby', 'Go')
    end
  end

  describe 'GET /tags/:id' do
    it 'returns 200 with the tag when found' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      get "/tags/#{id}"
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['name']).to eq('Ruby')
      expect(body['color']).to eq('#ff0000')
    end

    it 'returns 404 when not found' do
      get '/tags/999'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end

  describe 'POST /tags' do
    it 'returns 201 with the created tag including an id' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      expect(last_response.status).to eq(201)
      body = JSON.parse(last_response.body)
      expect(body['id']).to be_a(Integer)
      expect(body['name']).to eq('Ruby')
      expect(body['color']).to eq('#ff0000')
    end

    it 'auto-increments ids' do
      post '/tags', { name: 'First', color: '#000000' }.to_json, headers
      first_id = JSON.parse(last_response.body)['id']
      post '/tags', { name: 'Second', color: '#ffffff' }.to_json, headers
      second_id = JSON.parse(last_response.body)['id']
      expect(second_id).to eq(first_id + 1)
    end
  end

  describe 'PUT /tags/:id' do
    it 'returns 200 with the updated tag when found' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      put "/tags/#{id}", { name: 'Ruby 3', color: '#cc0000' }.to_json, headers
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['name']).to eq('Ruby 3')
      expect(body['color']).to eq('#cc0000')
      expect(body['id']).to eq(id)
    end

    it 'returns 404 when not found' do
      put '/tags/999', { name: 'X', color: '#000000' }.to_json, headers
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end

  describe 'DELETE /tags/:id' do
    it 'returns 204 with no body when found' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      delete "/tags/#{id}"
      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_empty
    end

    it 'removes the tag from the store' do
      post '/tags', { name: 'Ruby', color: '#ff0000' }.to_json, headers
      id = JSON.parse(last_response.body)['id']

      delete "/tags/#{id}"
      get "/tags/#{id}"
      expect(last_response.status).to eq(404)
    end

    it 'returns 404 when not found' do
      delete '/tags/999'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('not found')
    end
  end
end

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

  describe 'GET /changes' do
    it 'returns 200 with a list of change entries' do
      get '/changes'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body).to be_an(Array)
      expect(body).not_to be_empty
      expect(body.first).to include('action', 'timestamp', 'description')
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
