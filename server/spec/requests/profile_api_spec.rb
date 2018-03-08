# spec/requests/profile_api_spec.rb
require 'rails_helper'

RSpec.describe 'profile API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers }

  describe 'GET /api/profile' do
    before { get '/api/profile', params: {}, headers: headers }

    it 'returns profile' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns name and email' do
      expect(response.body.to_json['name']).not_to be_nil
      expect(response.body.to_json['email']).not_to be_nil
    end

  end

end

