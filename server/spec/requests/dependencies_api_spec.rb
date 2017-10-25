# spec/requests/dependencies_api_spec.rb
require 'rails_helper'

RSpec.describe 'dependencies API' do
  let(:user) { create(:user) }
  let! (:project) {create(:project)}
  let!(:scan) { create(:scan, project_id: project.id) }
  let!(:dependencies) { create_list(:dependency, 20, scan_id: scan.id) }
  let(:project_id) { project.id }
  let(:scan_id) { scan.id}
  let(:id) { dependencies.first.id }
  let(:headers) { valid_headers }

  describe 'GET /projects/:project_id/scans/:scan_id/dependencies' do
    before { get "/projects/#{project_id}/scans/#{scan_id}/dependencies", params: {}, headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all dependencies' do
        expect(json.size).to eq(20)
      end
    end

    context 'when project does not exist' do
      let(:project_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  describe 'GET /projects/:project_id/scans/:scan_id/dependencies/:id' do
    before { get "/projects/#{project_id}/scans/#{scan_id}/dependencies/#{id}", params: {}, headers: headers }
    context 'when dependency exists' do
      it 'returns status code 200' do
        response.body
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when dependency does not exist' do
      let(:id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Dependency/)
      end
    end
  end

  describe 'POST /projects/:project_id/scans/:scan_id/dependencies' do
    let(:valid_attributes) { { name: 'Test', version: '1.2.3', language: 'ruby', raw: 'fewf', done: false }.to_json }

    context 'when request attributes are valid' do
      before do post "/projects/#{project_id}/scans/#{scan_id}/dependencies", params: valid_attributes, headers: headers end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/projects/#{project_id}/scans/#{scan_id}/dependencies", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /projects/:project_id/dependencies/:id' do
    let(:valid_attributes) { { name: 'Test', version: '1.2.3', language: 'ruby', raw: 'fewf', done: false }.to_json }

    before do
      put "/projects/#{project_id}/scans/#{scan_id}/dependencies/#{id}", params: valid_attributes, headers: headers
    end

    context 'when dependency exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the dependency' do
        #TODO fix
        # expect(Dependency.find(id)).to match('')
      end
    end

    context 'when the dependency does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Dependency/)
      end
    end
  end

  describe 'DELETE /projects/:project_id/scans/:scan_id/dependencies/:id' do
    before { delete "/projects/#{project_id}/scans/#{scan_id}/dependencies/#{id}", params: {}, headers: headers }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

  end
end