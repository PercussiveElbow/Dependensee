# spec/requests/cve_api_spec.rb
require 'rails_helper'

RSpec.describe 'CVE API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers }

  describe 'GET /cve/:id' do
    before { get "/cve/#{cve_id}", params: {}, headers: headers }

    context 'when the java cve exists' do
      let(:cve_id) { '2017-14063' }
      it 'returns the cve' do
        expect(json).not_to be_empty
        expect(json['cve_id']).to eq(cve_id)
        expect(json['cvss2']).to eq('5.0')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the java cve does not exist' do
      let(:cve_id) { 'fakecve' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Not found")
      end
    end


    context 'when the python cve exists' do
      let(:cve_id) { '2014-7143'}
      it 'returns the cve' do
        expect(json).not_to be_empty
        expect(json['cve_id']).to eq(cve_id)
        expect(json['cvss2']).to eq('3.3')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the python cve does not exist' do
      let(:cve_id) { 'fakecve' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Not found")
      end
    end


    context 'when the ruby cve exists' do
      let(:cve_id) { '2017-9050'}
      it 'returns the cve' do
        expect(json).not_to be_empty
        expect(json['cve_id']).to eq(cve_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the ruby cve does not exist' do
      let(:cve_id) { 'fakecve' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Not found")
      end
    end


  end
end

