# spec/requests/updates_api_spec.rb
require 'rails_helper'

RSpec.describe 'updates API' do
  let(:user) { create(:user) }

  let! (:project) {create(:project)}
  let!(:scan) { create(:scan, project_id: project.id) }
  let(:project_id) { project.id }
  let(:scan_id) { scan.id}
  let!(:dependency) { create(:dependency, scan_id: scan.id, version: '1.2.3', name: 'org.asynchttpclient.async-http-client') }
  let(:id) { dependency.id }

  let! (:ruby_project) {create(:project, language: 'Ruby')}
  let!(:ruby_scan) { create(:scan, project_id: ruby_project.id) }
  let(:ruby_project_id) { ruby_project.id }
  let(:ruby_scan_id) { ruby_scan.id}
  let!(:ruby_dependency) { create(:dependency, scan_id: ruby_scan.id, version: '1.2.3', name: 'activerecord') }
  let(:ruby_id) { ruby_dependency.id }

  let! (:python_project) {create(:project, language: 'Python')}
  let!(:python_scan) { create(:scan, project_id: python_project.id) }
  let(:python_project_id) { python_project.id }
  let(:python_scan_id) { python_scan.id}
  let!(:python_dependency) { create(:dependency, scan_id: python_scan.id, version: '1.2.3', name: 'selenium') }
  let(:python_id) { python_dependency.id }

  let(:headers) { valid_headers }

  describe 'POST /api/v1/projects/:project_id/scans/:scan_id/updates/:type/' do
    before { post "/api/v1/projects/#{project_id}/scans/#{scan_id}/updates/#{type}", params: {}, headers: headers }

    context 'when type is safe' do
      let(:type) {'safe'}
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a message' do
        expect(json['message']).to match("Scan #{scan_id} vulnerable dependencies set to safe")
      end

      it 'sets scan needs_update' do
        expect(json['message']).to match("")

      end
    end

    context 'when type is manual' do
      let(:type) {'manual'}
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a message' do
        expect(json['message']).to match("Scan #{scan_id} vulnerable dependencies set to manual")
      end

      it 'sets scan needs_update' do
        expect(json['message']).to match("")

      end
    end

    context 'when type is latest' do
      let(:type) {'latest'}
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a message' do
        expect(json['message']).to match("Scan #{scan_id} vulnerable dependencies set to latest")
      end

      it 'sets scan needs_update' do
        expect(json['message']).to match("")

      end
    end


    context 'when type is not support' do
      let(:type) {'griogioegoie'}
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a message' do
        expect(json['message']).to eql("Update type not supported. Support versions: Safe, Latest, Manual")
      end

      it 'sets scan needs_update' do
        expect(json['message']).to match("")

      end
    end


  end


end