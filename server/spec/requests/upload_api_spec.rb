# spec/requests/upload_api_spec.rb
require 'rails_helper'

RSpec.describe 'upload API' do
  let(:user) { create(:user) }

  let! (:project) {create(:project)}
  let(:project_id) { project.id }

  let! (:ruby_project) {create(:project, language: 'Ruby')}
  let(:ruby_project_id) { ruby_project.id }

  let! (:python_project) {create(:project, language: 'Python')}
  let(:python_project_id) { python_project.id }

  let(:headers) { valid_headers }

  describe 'POST /api/projects/:project_id/upload/' do
    before { post "/api/projects/#{project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/pom.xml.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project,scan,dependency exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

      it 'returns a scan id' do
        expect(json['scan_id']).not_to be_nil
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

  end


  describe 'POST /api/projects/:ruby_project_id/upload' do
    before { post "/api/projects/#{ruby_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/Gemfile.lock.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project,scan,dependency exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

    end
  end

  describe 'POST /api/projects/:python_project_id/upload' do
    before { post "/api/projects/#{python_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/requirements.txt.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project,scan,dependency exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

    end
  end

end