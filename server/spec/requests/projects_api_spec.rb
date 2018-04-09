# spec/requests/projects_api_spec.rb
require 'rails_helper'

RSpec.describe 'projects API', type: :request do
  let(:user) { create(:user) }
  let!(:projects) { create_list(:project, 10, owner: user.id) }
  let(:project_id) { projects.first.id }
  let(:headers) { valid_headers }

  describe 'GET /api/v1/projects' do
    before { get '/api/v1/projects', params: {}, headers: headers }

    it 'returns projects' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  describe 'GET /api/v1/projects/:id' do
    before { get "/api/v1/projects/#{project_id}", params: {}, headers: headers }

      context 'when the record exists' do
        it 'returns the project' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(project_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        let(:project_id) { 'c480b6dc-18de-11e8-accf-0ed5f89f718b' }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to include("Couldn't find Project")
        end

      end

    context 'when the record is not a UUID' do
      let(:project_id) { '100' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a not found message' do
        expect(response.body).to include('Validation error in one or more parameters')
      end
    end

  end

  describe 'POST /api/v1/projects' do
    let(:valid_attributes) do { name: 'AProject', owner: user.id.to_s,language:'Java'}.to_json end

    context 'when request is valid' do
      before { post '/api/v1/projects', params: valid_attributes, headers: headers }

      it 'creates a projects' do
        expect(json['name']).to eql('AProject')
        expect(json['language']).to eql('Java')
        expect(json['owner']).to eql(user.id.to_s)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      let(:valid_attributes) { { name: nil }.to_json }
      before { post '/api/v1/projects', params: valid_attributes, headers: headers }
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
              .to match("{\"message\":\"Validation failed: Name can't be blank, Name is too short (minimum is 3 characters), Language can't be blank, Language is not included in the list\"}")
        end
    end

    end

  describe 'PUT /api/v1/projects/:id' do
    let(:valid_attributes) { { name: 'aProject' }.to_json }

    context 'when the record exists' do
      before { put "/api/v1/projects/#{project_id}", params: valid_attributes, headers: headers }
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    before { delete "/api/v1/projects/#{project_id}", params: {}, headers: headers }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
  end

end

