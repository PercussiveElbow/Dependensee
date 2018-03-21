# spec/requests/reports_api_spec.rb
require 'rails_helper'

RSpec.describe 'reports API' do
  let(:user) { create(:user) }

  let! (:project) {create(:project)}
  let!(:scan) { create(:scan, project_id: project.id) }
  let(:project_id) { project.id }
  let(:scan_id) { scan.id}
  let!(:dependency) { create(:dependency, scan_id: scan.id, version: '1.2.3', name: 'org.asynchttpclient.async-http-client') }

  let! (:ruby_project) {create(:project, language: 'Ruby')}
  let!(:ruby_scan) { create(:scan, project_id: ruby_project.id) }
  let(:ruby_project_id) { ruby_project.id }
  let(:ruby_scan_id) { ruby_scan.id}
  let!(:ruby_dependency) { create(:dependency, scan_id: ruby_scan.id, version: '4.2.0', name: 'activerecord') }

  let! (:python_project) {create(:project, language: 'Python')}
  let!(:python_scan) { create(:scan, project_id: python_project.id) }
  let(:python_project_id) { python_project.id }
  let(:python_scan_id) { python_scan.id}
  let!(:python_dependency) { create(:dependency, scan_id: python_scan.id, version: '==14.0.0', name: 'Twisted') }

  let(:headers) { valid_headers }

  describe 'GET /api/v1/projects/:project_id/scans/:scan_id/reports/json' do
    before { get "/api/v1/projects/#{project_id}/scans/#{scan_id}/reports/json", params: {}, headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

      it 'returns all dependencies' do
        expect(json.size).to eq(1)
      end
    end

    context 'when project does not exist' do
      let(:project_id) { '2663776a-18e7-11e8-accf-0ed5f89f718b' }

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

      it 'returns a validation message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end

    context 'when project exists but the scan does not exist' do
      let(:scan_id) {'2663776a-18e7-11e8-accf-0ed5f89f718b'}
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a validation message' do
        expect(json['message']).to match(/Couldn't find Scan/)
      end
    end

    context 'when project exists but the scan is malformed' do
      let(:scan_id) {'a'}
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end

  end


  describe 'GET /api/v1/projects/:python_project_id/scans/:python_scan_id/reports/json' do
    before { get "/api/v1/projects/#{python_project_id}/scans/#{python_scan_id}/reports/json", params: {}, headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

      it 'returns all dependencies' do
        expect(json.size).to eq(1)
      end
    end
  end

  describe 'GET /api/v1/projects/:ruby_project_id/scans/:ruby_scan_id/reports/json' do
    before { get "/api/v1/projects/#{ruby_project_id}/scans/#{ruby_scan_id}/reports/json", params: {}, headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

      it 'returns all dependencies' do
        expect(json.size).to eq(1)
      end
    end
  end

end