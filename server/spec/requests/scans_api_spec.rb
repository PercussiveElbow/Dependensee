# spec/requests/scans_api_spec.rb
require 'rails_helper'

RSpec.describe 'scans API', type: :request do
  let(:user) { create(:user) }
  let!(:project) { create(:project, owner: user.id) }
  let!(:scans) { create_list(:scan, 20, project_id: project.id) }
  let(:project_id) { project.id }
  let(:id) { scans.first.id }
  let(:headers) { valid_headers }

  describe 'GET /projects/:project_id/scans' do
    before { get "/projects/#{project_id}/scans", params: {}, headers: headers }

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

  describe 'GET /projects/:project_id/scans/:id' do
    before { get "/projects/#{project_id}/scans/#{id}", params: {}, headers: headers }
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

  describe 'POST /projects/:project_id/scans' do
    let(:valid_attributes) { {source: 'Test'}.to_json }

    context 'when request attributes are valid' do
      before do post "/projects/#{project_id}/scans", params: valid_attributes, headers: headers end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_headers) { { name: 'rejrhgrhghughugur'}.to_json }

      before { post "/projects/#{project_id}/scans", params: {}, headers: headers }
      #
      # it 'returns status code 422' do
      #   expect(response).to have_http_status(422)
      # end
      #
      # it 'returns a failure message' do
      #   expect(response.body).to match(/Validation failed: Source can't be blank/)
      # end
    end
  end

  describe 'PUT /projects/:project_id/scans/:id' do
    let(:valid_attributes) { { name: 'Test', version: '1.2.3', language: 'ruby', raw: 'fewf', done: false }.to_json }

    before do
      put "/projects/#{project_id}/scans/#{id}", params: valid_attributes, headers: headers
    end

    context 'when scan exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the scan' do
        #TODO fix
        # expect(scan.find(id)).to match('')
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

  describe 'DELETE /projects/:project_id/scans/:id' do
    before { delete "/projects/#{project_id}/scans/#{id}", params: {}, headers: headers }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

  end
end