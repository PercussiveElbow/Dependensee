# spec/requests/users_api_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'POST /signup' do
    context 'valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created/)
      end

      it 'returns auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'doesnt create user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end
end