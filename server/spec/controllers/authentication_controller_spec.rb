# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }

    let(:valid_credentials) do
      {email: user.email, password: user.password}.to_json
    end

    let(:invalid_credentials) do
      {email: Faker::Internet.email, password: Faker::Internet.password}.to_json
    end

    context 'valid request' do
      before { post '/api/v1/auth/login', params: valid_credentials, headers: headers }

      it 'returns auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'invalid request' do
      before { post '/api/v1/auth/login', params: invalid_credentials, headers: headers }

      it 'returns failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end