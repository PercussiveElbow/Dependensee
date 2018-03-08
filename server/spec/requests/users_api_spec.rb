# spec/requests/users_api_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:user_existing) { create(:user, name: 'abc', email: 'test123@gmail.com', password: 'apassword', password_confirmation: 'apassword').save! }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'POST /api/signup' do
    context 'valid request' do
      before { post '/api/signup', params: valid_attributes.to_json, headers: headers }

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
      before { post '/api/signup', params: {}, headers: headers }

      it 'doesnt create user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end
  end


  describe 'POST /api/login' do
    context 'valid request' do
      before { post '/api/login', params: {name:  'abc', email: 'eioefiwfiowefiwo'}.to_json, headers: headers }

      it 'returns a 422 when validation fails' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Validation error in one or more parameters/)
      end
    end
  end

  describe 'POST /api/login' do
    context 'valid request' do
      before(:each) {post '/api/signup', params: user_existing.to_json, headers: headers}
      before { post '/api/login', params: {email: 'test123@gmail.com',password: 'apassword'}.to_json, headers: headers }

      it 'logs in successfully' do
        expect(response).to have_http_status(201)
      end

      it 'returns auth key' do
        expect(json['message']).to match("Logged on. New Token generated")
      end

      it 'returns auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end
  end

end