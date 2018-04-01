# spec/requests/scans_api_spec.rb
require 'rails_helper'

RSpec.describe 'scans API', type: :request do
  let(:user) { create(:user) }
  let!(:project) { create(:project, owner: user.id) }
  let!(:scans) { create_list(:scan, 20, project_id: project.id, needs_update: false) }
  let(:project_id) { project.id }
  let(:id) { scans.first.id }
  let(:headers) { valid_headers }

  describe 'GET /api/v1/projects/:project_id/scans' do
    before { get "/api/v1/projects/#{project_id}/scans", params: {}, headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all scans' do
        expect(json.size).to eq(20)
      end
    end

    context 'when project does not exist' do
      let(:project_id) { 'c480ba7e-18de-11e8-accf-0ed5f89f718b' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end


    context 'when project id is malformed' do
      let(:project_id) { 'a' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end
  end

  describe 'GET /api/v1/projects/:project_id/scans/:id' do
    before { get "/api/v1/projects/#{project_id}/scans/#{id}", params: {}, headers: headers }
    context 'when scan exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when scan does not exist' do
      let(:id) { 'c480ba7e-18de-11e8-accf-0ed5f89f718b' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Scan")
      end
    end

    context 'when scan id is malformed' do
      let(:id) { 'a' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end
  end

  describe 'POST /api/v1/projects/:project_id/scans' do
    let(:valid_attributes) { {source: 'Test'}.to_json }

    context 'when request attributes are valid' do
      before do post "/api/v1/projects/#{project_id}/scans", params: valid_attributes, headers: headers end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /api/v1/projects/:project_id/scans/:id' do
    let(:valid_attributes) { { source: 'newsource', needs_update: 'true' }.to_json }

    before do
      put "/api/v1/projects/#{project_id}/scans/#{id}", params: valid_attributes, headers: headers
    end

    context 'when scan exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the scan' do
        expect(Scan.find(id).source).to match('newsource')
        expect(Scan.find(id).needs_update).to match(true)
      end
    end

    context 'when the scan does not exist' do
      let(:id) { '2663776a-18e7-11e8-accf-0ed5f89f718b' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find Scan")
      end
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/scans/:id' do
    before { delete "/api/v1/projects/#{project_id}/scans/#{id}", params: {}, headers: headers }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

  end
end