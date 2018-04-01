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

  let! (:java_project) {create(:project, language: 'Java')}
  let(:java_project_id) {java_project.id}

  let! (:project_auto_update) {create(:project, language: 'Python', auto_update: true)}
  let(:auto_project_id) {project_auto_update.id}

  let(:headers) { valid_headers }

  describe 'POST /api/v1/projects/:project_id/upload/' do
    before { post "/api/v1/projects/#{project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/pom.xml.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project exists' do
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

  describe 'POST /api/v1/projects/:java_project_id/upload/' do
    context 'when dependencies are all empty' do
      it 'raises an EmptyDependencyException' do
        expect{post "/api/v1/projects/#{java_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/pom.xml.empty.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }.to raise_error(CustomException::EmptyDependencyException)
      end
    end
  end


  describe 'POST /api/v1/projects/:ruby_project_id/upload' do
    before { post "/api/v1/projects/#{ruby_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/Gemfile.lock.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

    end
  end

  describe 'POST /api/v1/projects/:python_project_id/upload' do
    before { post "/api/v1/projects/#{python_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/requirements.txt.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

    end
  end

  describe 'POST /api/v1/projects/:auto_project_id/upload' do
    before { post "/api/v1/projects/#{auto_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/requirements.txt.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project exists and upload to auto update scan will need update' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
        expect(Scan.find(json['scan_id'] ).needs_update).to eql(true)
      end

    end
  end

  describe 'POST /api/v1/projects/:ruby_project_id/upload' do
    before { post "/api/v1/projects/#{ruby_project_id}/upload/",  params: File.read(File.expand_path(File.dirname(__FILE__) + '../../resources/Gemfile.lock.test')) , headers: { 'Content-Type' => 'text/plain', 'Authorization' => valid_headers['Authorization']} }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end

    end
  end

end